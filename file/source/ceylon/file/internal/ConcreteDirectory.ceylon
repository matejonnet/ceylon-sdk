import ceylon.file { ... }
import ceylon.file.internal { Util { newPath, deletePath, movePath, 
                                     newDirectory, newFile } }
import java.nio.file { JPath=Path, Files { newDirectoryStream } }

class ConcreteDirectory(JPath jpath)
        extends ConcreteResource(jpath) 
        satisfies Directory {
    shared actual Path[] childPaths {
        value sb = SequenceBuilder<Path>();
        value iter = newDirectoryStream(jpath).iterator();
        while (iter.hasNext()) {
            sb.append(ConcretePath(iter.next()));
        }
        return sb.sequence;
    }
    shared actual Empty|Sequence<File|Directory> children {
        value sb = SequenceBuilder<File|Directory>();
        for (p in childPaths) {
            if (is File|Directory r=p.resource) {
                sb.append(r);
            }
        }
        return sb.sequence;
    }
    shared actual File[] files {
        value sb = SequenceBuilder<File>();
        for (p in childPaths) {
            if (is File r=p.resource) {
                sb.append(r);
            }
        }
        return sb.sequence;
    }
    shared actual Directory[] childDirectories {
        value sb = SequenceBuilder<Directory>();
        for (p in childPaths) {
            if (is Directory r=p.resource) {
                sb.append(r);
            }
        }
        return sb.sequence;
    }
    shared actual Resource childResource(Path|String subpath) {
        return path.childPath(subpath).resource();
    }
    shared actual Nil delete() {
        deletePath(jpath);
        return ConcreteNil(jpath);
    }
    shared actual Directory move(Nil target) {
        return ConcreteDirectory( movePath(jpath, asJPath(target.path)) );
    }
}