function assertEquals(expected, actual)
    if expected ~= actual then
        print(string.format("Expected %s but was %s", expected, actual))
        assert(false)
    end
end

function assertTableEquals(expected, actual)
    expected = table.concat(expected)
    actual = table.concat(actual)
    assertEquals(expected, actual)
end