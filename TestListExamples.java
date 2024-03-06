import static org.junit.Assert.*;
import org.junit.*;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.List;

class IsMoon implements StringChecker {
  public boolean checkString(String s) {
    return s.equalsIgnoreCase("moon");
  }
}

public class TestListExamples {
  @Test(timeout = 500)
  public void testMergeRightEnd() {
    List<String> left = Arrays.asList("a", "b", "c");
    List<String> right = Arrays.asList("a", "d");
    List<String> merged = ListExamples.merge(left, right);
    List<String> expected = Arrays.asList("a", "a", "b", "c", "d");
    assertEquals(expected, merged);
  }

  @Test(timeout = 500)
  public void testMergeEmpty() {
    List<String> list1 = new ArrayList<>();
    List<String> list2 = new ArrayList<>();
    list2.add("a");
    list2.add("b");
    list2.add("d");
    list2.add("e");
    List<String> expected = new ArrayList<>();
    expected.add("a");
    expected.add("b");
    expected.add("d");
    expected.add("e");

    assertEquals(expected, ListExamples.merge(list1,list2));
    assertEquals(expected, ListExamples.merge(list2,list1));
  }

  @Test(timeout = 500)
  public void testFilter() {
    List<String> list1 = new ArrayList<>();
    list1.add("sun");
    list1.add("SUN");
    list1.add("moon");
    list1.add("MOON");
    list1.add("hotdog");

    List<String> expected = new ArrayList<>();
    expected.add("moon");
    expected.add("MOON");

    assertEquals(expected, ListExamples.filter(list1, new IsMoon()));
  }
}
