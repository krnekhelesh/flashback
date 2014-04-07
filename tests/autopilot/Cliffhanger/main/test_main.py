# -*- Mode: Python; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-

"""Tests for the Hello World"""

from autopilot.matchers import Eventually
from textwrap import dedent
from testtools.matchers import Is, Not, Equals
from testtools import skip
import os
from Cliffhanger import UbuntuTouchAppTestCase


class MainTests(UbuntuTouchAppTestCase):
    """Generic tests for the Hello World"""

    test_qml_file = "%s/%s.qml" % (os.path.dirname(os.path.realpath(__file__)),"../../../../Cliffhanger")

    def test_0_can_select_mainView(self):
        """Must be able to select the mainview."""

        mainView = self.get_mainview()
        self.assertThat(mainView.visible,Eventually(Equals(True)))

