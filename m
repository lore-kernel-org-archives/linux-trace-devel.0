Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C0E2C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Feb 2022 15:24:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243596AbiBJPX6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Feb 2022 10:23:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243602AbiBJPX4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Feb 2022 10:23:56 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E6D18C
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Feb 2022 07:23:57 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id s18so10203648wrv.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Feb 2022 07:23:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qrfxDYs03c9SXOa1wsaaQuPgrmWLTFytZgPGHRlQl6Q=;
        b=YgO5/hXPruCczPoxPVnfG8vceyNigbYCyDtoSHUiuPJAgTPTEKIkt4M8ijExrWVFuk
         Pm/awt0DUzrjbL46o6x8higMVeEuxA8JFoohAwLTVA6H6OJrOz9lfwwOim47LsmzWha2
         OnXxF5vCQ+43gU9SH0m5UiSFQJTA+Vk+54abPihqtETJU+3M1YugUSy22chLZFwP47E8
         SPvY/F8ZmvEkBmkBtoSmD/Ev2MB42ZbulTZYykVOwvnHl3Mbgqd3btvjO5Tij0qTNvN0
         vNLWs1NoMhVr65+j0uzIag+f7fBOW6NKcNSZWhGk7Q+yN563I3a4G44dt4ds525kkvyu
         C7qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qrfxDYs03c9SXOa1wsaaQuPgrmWLTFytZgPGHRlQl6Q=;
        b=Q2Na2S5B7o11ZyoO6h71e+dRcvfkFULm1a5p9+fVdlpg9DjookLRvTAx1Pjjbnmimc
         YPM/Qg1s9t1DfUXygo4LbHzaOgdo1UkIKApAONtj6qj4ojmQXPoRKJRNOahVQp8hMNHq
         4b+iDX1ltX2mIAm7mvn6+Mn3Rxa4Zsn63OuEqmRFVcqA+V0+Y0hK4Pm45ImWrffjimIZ
         U0pQIkxh1gNOEXf/VEQCvdgS8cAHTRTZeZsEIKNgD+ovG7452/hzxmZOrLqwdGwrWGsu
         y1LgVlygkcEJR8y9L/UH/Hc8+WCcVYDsDPtGz/8OFXZVucxm4eCsU3QZ7NeuYd4NM3JN
         eKMA==
X-Gm-Message-State: AOAM531NdYFDPKZrQI+HbC+SwGuQ01cXDNqvykZHI+xWQ5DoeA9N1+Dy
        sllYMSTBVY7Caxnj1xX/agpq+2vBI4w=
X-Google-Smtp-Source: ABdhPJx+VjJ7+mCQh9kTidc48RJknQkbTy3ffRqB6bYzZ1l3ofOA6nwYgaZjTee/4SrYRCRuneyX5Q==
X-Received: by 2002:a5d:5264:: with SMTP id l4mr6654739wrc.483.1644506635491;
        Thu, 10 Feb 2022 07:23:55 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id j15sm2245301wmq.19.2022.02.10.07.23.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 07:23:55 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/8] trace-cruncher: Add tests for synth helper APIs
Date:   Thu, 10 Feb 2022 17:23:34 +0200
Message-Id: <20220210152339.363943-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220210152339.363943-1-y.karadz@gmail.com>
References: <20220210152339.363943-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Test cases for the helpers, providing a descriptor strings for synthetic
fields. The patch includes a fix of a bug discovered with the new tests.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 tracecruncher/ft_utils.py                     |  6 ++---
 .../tests/1_unit/test_01_ftracepy_unit.py     | 22 +++++++++++++++++++
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/tracecruncher/ft_utils.py b/tracecruncher/ft_utils.py
index 7e0e642..6db426e 100644
--- a/tracecruncher/ft_utils.py
+++ b/tracecruncher/ft_utils.py
@@ -425,10 +425,8 @@ def synth_field_rename(event, field, name):
 def synth_field_deltaT(name='delta_T', hd=False):
     """ Create descriptor for time-diference synthetic field.
     """
-    if hd:
-        return 'delta_t {0} hd'.format(name)
-
-    return 'delta_t {0} hd'.format(name)
+    d = 'delta_t {0}'.format(name)
+    return (d, d+' hd')[hd]
 
 
 def synth_field_delta_start(name, start_field, end_field):
diff --git a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
index aea29db..f942b6b 100644
--- a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
+++ b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
@@ -829,6 +829,28 @@ swaking = tc.tc_event('sched', 'sched_waking')
 sswitch = tc.tc_event('sched', 'sched_switch')
 
 class SynthOopTestCase(unittest.TestCase):
+    def test_field_deltaT(self):
+        f =  tc.synth_field_deltaT()
+        self.assertEqual(f, 'delta_t delta_T')
+        f =  tc.synth_field_deltaT(hd=True)
+        self.assertEqual(f, 'delta_t delta_T hd')
+        f =  tc.synth_field_deltaT(name='dT', hd=True)
+        self.assertEqual(f, 'delta_t dT hd')
+        f =  tc.synth_field_deltaT(name='dT', hd=False)
+        self.assertEqual(f, 'delta_t dT')
+
+    def test_field_delta_start(self):
+        f =  tc.synth_field_delta_start('dS', 'foo', 'bar')
+        self.assertEqual(f, 'delta_start dS foo bar')
+
+    def test_field_delta_end(self):
+        f =  tc.synth_field_delta_end('dE', 'foo', 'bar')
+        self.assertEqual(f, 'delta_end dE foo bar')
+
+    def test_field_sum(self):
+        f =  tc.synth_field_sum('Sm', 'foo', 'bar')
+        self.assertEqual(f, 'sum Sm foo bar')
+
     def test_synt_create(self):
         start = tc.synth_event_item(event=swaking,
                                     fields=['target_cpu', 'prio'],
-- 
2.32.0

