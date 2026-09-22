package ratalada;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.Operation;
import io.swagger.v3.oas.models.servers.Server;
import org.openapitools.codegen.CodegenOperation;
import org.openapitools.codegen.SupportingFile;
import org.openapitools.codegen.languages.RubySinatraServerCodegen;

import java.io.File;
import java.net.URI;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

/**
 * The ruby-sinatra generator, with the two things a template cannot reach:
 * which operations share a file, and what that file is called.
 *
 * Upstream writes one file per tag. A file-based router needs one file per
 * PATH, because the path IS the file name -- `/repos/{owner}/{repo}` is
 * `repos/[owner]/[repo]/index.rb`, and Mustermann::Expo reads it back.
 *
 * Everything else -- what a handler looks like, what it answers -- is the
 * template's and the document's, not this class's.
 */
public class ExpoCodegen extends RubySinatraServerCodegen {

    /** Every path in the document: a path that prefixes another is a directory. */
    private final Set<String> paths = new TreeSet<>();

    /** The servers' common prefix, which the tree hangs off. */
    private String base = "";

    public ExpoCodegen() {
        super();
        outputFolder = "generated-code" + File.separator + "ratalada";
    }

    @Override
    public void processOpts() {
        super.processOpts();

        // One template, one file per path, and none of the Sinatra app
        // scaffolding: the router is the file tree.
        apiTemplateFiles.clear();
        apiTemplateFiles.put("page.mustache", ".rb");
        setApiPackage("app");

        // The models, as data rather than as code: every schema with its
        // columns, their types and which of them are other models. What
        // persists them -- relations, structs, tables -- is built from this,
        // the same way postgresql-schema builds DDL from it.
        supportingFiles.clear();
        supportingFiles.add(new SupportingFile("models.mustache", "", "models.json"));
    }

    @Override
    public String getName() {
        return "ratalada-expo";
    }

    @Override
    public String getHelp() {
        return "Generates Ratalada file-based route pages (one file per path, Expo spelling).";
    }

    @Override
    public void preprocessOpenAPI(OpenAPI openAPI) {
        super.preprocessOpenAPI(openAPI);

        if (openAPI.getPaths() != null) {
            paths.addAll(openAPI.getPaths().keySet());
        }

        List<Server> servers = openAPI.getServers();
        if (servers != null && !servers.isEmpty()) {
            base = pathOf(servers.get(0).getUrl());
        }
    }

    /**
     * The group key is the path, so every operation on it lands in one file.
     *
     * An operation carrying two tags is offered twice -- once per tag, which
     * upstream files under two different names. Here both offers name the same
     * file, so the second one is a duplicate handler.
     */
    @Override
    public void addOperationToGroup(String tag, String resourcePath, Operation operation,
                                    CodegenOperation co, Map<String, List<CodegenOperation>> operations) {
        List<CodegenOperation> group = operations.get(resourcePath);

        if (group != null && group.stream().anyMatch(existing -> existing.operationId.equals(co.operationId))) {
            return;
        }

        super.addOperationToGroup(resourcePath, resourcePath, operation, co, operations);
    }

    /** `/repos/{owner}/{repo}` -> `api/v1/repos/[owner]/[repo]/index` */
    @Override
    public String toApiFilename(String name) {
        String spelled = base + name.replaceAll("\\{([^{}/]+)\\}", "[$1]");
        String trimmed = trim(spelled);

        if (trimmed.isEmpty()) {
            return "index";
        }
        if (isDirectory(name)) {
            return trimmed + "/index";
        }
        return trimmed;
    }

    @Override
    public String apiFileFolder() {
        return outputFolder + File.separator + apiPackage.replace("/", File.separator);
    }

    /** A path that another path hangs off cannot also be a leaf file. */
    private boolean isDirectory(String path) {
        String prefix = trim(path) + "/";

        return paths.stream().anyMatch(other -> trim(other).startsWith(prefix));
    }

    private String trim(String path) {
        String trimmed = path;
        while (trimmed.startsWith("/")) {
            trimmed = trimmed.substring(1);
        }
        while (trimmed.endsWith("/")) {
            trimmed = trimmed.substring(0, trimmed.length() - 1);
        }
        return trimmed;
    }

    /** A server URL may be absolute; only its path is a prefix for the tree. */
    private String pathOf(String url) {
        try {
            String path = URI.create(url).getPath();
            return path == null ? "" : path;
        } catch (IllegalArgumentException invalid) {
            return url.startsWith("/") ? url : "";
        }
    }
}
