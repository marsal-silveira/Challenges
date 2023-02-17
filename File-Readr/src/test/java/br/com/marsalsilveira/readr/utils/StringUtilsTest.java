package br.com.marsalsilveira.readr.utils;


import org.junit.Assert;
import org.junit.Test;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static org.hamcrest.core.Is.is;
import static org.hamcrest.core.IsNot.not;

/**
 * Unit test for StringUtils.
 */
public class StringUtilsTest {

    @Test
    public void testIsEmpty() {

        Assert.assertEquals(true, StringUtils.isEmpty(null));
        Assert.assertEquals(true, StringUtils.isEmpty(""));
        Assert.assertEquals(true, StringUtils.isEmpty(" "));
        Assert.assertEquals(false, StringUtils.isEmpty("abc"));
        Assert.assertEquals(false, StringUtils.isEmpty(" abc "));
    }

    @Test
    public void testIsNotEmpty() {

        Assert.assertEquals(false, StringUtils.isNotEmpty(null));
        Assert.assertEquals(false, StringUtils.isNotEmpty(""));
        Assert.assertEquals(false, StringUtils.isNotEmpty(" "));
        Assert.assertEquals(true, StringUtils.isNotEmpty("abc"));
        Assert.assertEquals(true, StringUtils.isNotEmpty(" abc "));
    }

    @Test
    public void testStripAccents() {

        Assert.assertEquals(null, StringUtils.stripAccents(null));
        Assert.assertEquals("", StringUtils.stripAccents(""));
        Assert.assertEquals("File Readr", StringUtils.stripAccents("File Readr"));
        Assert.assertEquals("Sao Jose - SC", StringUtils.stripAccents("São José - SC"));
        Assert.assertEquals("d'agua", StringUtils.stripAccents("d'água"));
        Assert.assertEquals("aAaAaAaA eEeEeE iIiIiI oOoOoOoO uUuUuU cC", StringUtils.stripAccents("àÀáÁâÂãÃ èÈéÉêÊ ìÌíÍîÎ òÒóÓôÔõÕ ùÙúÚûÛ çÇ"));
    }

    @Test
    public void testCollectionToString() {

        List<String> parts = Arrays.asList("file", "readr");
        Assert.assertThat("file readr", is(StringUtils.toString(parts)));
        Assert.assertThat("file readr", not(StringUtils.toString(parts, 2)));
        Assert.assertThat("readr", is(StringUtils.toString(parts, 1)));
        Assert.assertThat("", is(StringUtils.toString(parts, 3)));
        Assert.assertThat(null, is(StringUtils.toString(null)));
    }
}