package {
import ru.kokorin.astream.AStreamTest;
import ru.kokorin.astream.mapper.MapperSuite;
import ru.kokorin.astream.util.TypeUtilTest;

[Suite(description="All tests for AStream library")]
[RunWith("org.flexunit.runners.Suite")]
public class AllTests {
    public var typeUtil:TypeUtilTest;
    public var mapperSuite:MapperSuite;
    public var aStream:AStreamTest;
}
}
