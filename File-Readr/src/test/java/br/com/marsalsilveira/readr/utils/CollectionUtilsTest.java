package br.com.marsalsilveira.readr.utils;


import org.junit.Assert;
import org.junit.Test;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static org.hamcrest.core.Is.is;
import static org.hamcrest.core.IsNot.not;

/**
 * Unit test for CollectionUtils.
 */
public class CollectionUtilsTest {

    @Test
    public void testIsEmpty() {

        Assert.assertEquals(true, CollectionUtils.isEmpty(Arrays.asList()));
        Assert.assertEquals(false, CollectionUtils.isEmpty(Arrays.asList(Arrays.asList("file", "readr"))));
    }

    @Test
    public void testIsNotEmpty() {

        Assert.assertEquals(false, CollectionUtils.isNotEmpty(Arrays.asList()));
        Assert.assertEquals(true, CollectionUtils.isNotEmpty(Arrays.asList(Arrays.asList("file", "readr"))));
    }

    @Test
    public void testToList() {

        // null or empty
        List<String> nullOrEmpty = new ArrayList<>();
        Assert.assertThat(nullOrEmpty, is(CollectionUtils.toList(null)));
        Assert.assertThat(nullOrEmpty, is(CollectionUtils.toList("")));
        Assert.assertThat(nullOrEmpty, is(CollectionUtils.toList(" ")));

        // different
        List<String> different = Arrays.asList("file", "readr");
        Assert.assertThat(different, not(CollectionUtils.toList("readr")));

        // two parts
        List<String> twoParts = Arrays.asList("count", "*");
        Assert.assertThat(twoParts, is(CollectionUtils.toList("count *")));
        Assert.assertThat(twoParts, is(CollectionUtils.toList(" count  * ")));

        // three parts
        List<String> threeParts = Arrays.asList("filter", "uf", "sc");
        Assert.assertThat(threeParts , is(CollectionUtils.toList("filter uf sc")));
        Assert.assertThat(threeParts , is(CollectionUtils.toList(" filter  uf  sc ")));
    }
}