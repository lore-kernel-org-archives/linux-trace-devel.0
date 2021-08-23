Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71F10C4338F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Aug 2021 09:56:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F7836137A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Aug 2021 09:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbhHWJ5S (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 23 Aug 2021 05:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235905AbhHWJ5R (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 23 Aug 2021 05:57:17 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C53C061757
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 Aug 2021 02:56:34 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id u3so35816734ejz.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 Aug 2021 02:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U3MQE2AamaoVBbnPfL+qk1s9Z6NP0o6v1lmi+5EDpJo=;
        b=XVXNpg80AWPi/EF7szD+3DKzAy6qeJowrj+uob/OQdbnAoSDoSx0uu7Ih41REmttTe
         GwwLRUlQoqIixN3HHUB9VlT+hW2CHYRH/GTkwXgtdEMWw2nDWFxLDO1X26WebbbiFMRm
         cmDP7fFDDtmI7VRhqfB+QghTHf6bLmpDRB6V0QpmbT4zK9eD5O/h/fXUkFbSwXKZBsll
         KsLv8RpqExCF6bd3l25g2mXUhwAiQpu5XUwuN82AwCs1Q/Z42DJj/uT+YbQm6B+9xmUp
         3BAoWlz+NoT84fkN62S0yshhfgNqIHE48UG5RY+JmX2DEFAgpIhZCCt7XXO4m/nwSuBj
         Op5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U3MQE2AamaoVBbnPfL+qk1s9Z6NP0o6v1lmi+5EDpJo=;
        b=tWhtrH/eaU/PuXzJFaIiXCpBDEL/jlcWBx2BCOPleEdkOLBXUhz2T43m66uERDyNM+
         ikJ1Wd4M48FczhmR9lmhAhiNJ0LiUWXL/xqz7RnERXKS3Jkpp3HGgbB4GUvKpHXlP3NS
         LpfH0r7S7KPWe+Io+IS/jc17FtFewu8rVzXL3E0vwhzGCJ3jD59qs06w/M7HvDhHRgFb
         guJs1mz838TZ68eG/MozC8Nip0puGHGqKKz+64z+21DKa6B4E+U0WhBbXGjivTMAAe1R
         A7EriiYWhyiJ9YAXb0uI6DXHLNUUNGu1bvO0KH6ES+5wNqHYxunq+tUwtqyVERHDRspv
         AIxg==
X-Gm-Message-State: AOAM532IuMzAld5xlQRa7O+Xvqw3Mxz6UWC+10WUqMzmNpKTPycilXAn
        jeW8w8Z8zWLWndh68xXPi/0=
X-Google-Smtp-Source: ABdhPJzYVkFuOHItcalJ5V/YfbvyK+WZXbLbrTKi46jK1dp5omUv5OWDkkXuOfnThUoWYBMLrgIBKw==
X-Received: by 2002:a17:907:1b1b:: with SMTP id mp27mr34058936ejc.538.1629712593482;
        Mon, 23 Aug 2021 02:56:33 -0700 (PDT)
Received: from crow.. ([95.87.199.109])
        by smtp.gmail.com with ESMTPSA id y23sm7047831ejp.115.2021.08.23.02.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 02:56:33 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v7 4/4] libtraceevent: Add documentation for the new printing APIs
Date:   Mon, 23 Aug 2021 12:56:18 +0300
Message-Id: <20210823095618.138887-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210823095618.138887-1-y.karadz@gmail.com>
References: <20210823095618.138887-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

'tep_record_print_fields()' and 'tep_record_print_selected_fields()'
are documented.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 Documentation/libtraceevent-field_print.txt | 11 ++++++++++-
 Documentation/libtraceevent.txt             |  2 ++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtraceevent-field_print.txt b/Documentation/libtraceevent-field_print.txt
index 2c2cf6c..2b001e3 100644
--- a/Documentation/libtraceevent-field_print.txt
+++ b/Documentation/libtraceevent-field_print.txt
@@ -3,7 +3,7 @@ libtraceevent(3)
 
 NAME
 ----
-tep_print_field, tep_print_fields, tep_print_num_field, tep_print_func_field -
+tep_print_field, tep_print_fields, tep_record_print_fields, tep_record_print_selected_fields, tep_print_num_field, tep_print_func_field -
 Print the field content.
 
 SYNOPSIS
@@ -15,6 +15,8 @@ SYNOPSIS
 
 void *tep_print_field*(struct trace_seq pass:[*]_s_, void pass:[*]_data_, struct tep_format_field pass:[*]_field_);
 void *tep_print_fields*(struct trace_seq pass:[*]_s_, void pass:[*]_data_, int _size_, struct tep_event pass:[*]_event_);
+void *tep_record_print_fields*(struct trace_seq pass:[*]_s_, struct tep_record pass:[*]_record_, struct tep_event pass:[*]_event_);
+void *tep_record_print_selected_fields*(struct trace_seq pass:[*]_s_, struct tep_record pass:[*]_record_, struct tep_event pass:[*]_event_, int _ignore_mask_);
 int *tep_print_num_field*(struct trace_seq pass:[*]_s_, const char pass:[*]_fmt_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, int _err_);
 int *tep_print_func_field*(struct trace_seq pass:[*]_s_, const char pass:[*]_fmt_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, int _err_);
 --
@@ -35,6 +37,13 @@ value according to the field's type:
 It iterates all fields of the _event_, and calls _tep_print_field()_ for each of
 them.
 
+The _tep_print_selected_fields()_ prints the field's name followed by its value
+for all record's field.
+
+The _tep_print_selected_fields()_ prints the field's name followed by its value
+for selected subset of record field. The fields to be excluded from printing
+are defined by the _ignore_mask_ bit mask.
+
 The _tep_print_num_field()_ function prints a numeric field with given format
 string. A search is performed in the _event_ for a field with _name_. If such
 field is found, its value is extracted from the _record_ and is printed in the
diff --git a/Documentation/libtraceevent.txt b/Documentation/libtraceevent.txt
index d42b5c9..2d7318e 100644
--- a/Documentation/libtraceevent.txt
+++ b/Documentation/libtraceevent.txt
@@ -78,6 +78,8 @@ APIs related to fields from event's format files:
 Event fields printing:
 	void *tep_print_field*(struct trace_seq pass:[*]_s_, void pass:[*]_data_, struct tep_format_field pass:[*]_field_);
 	void *tep_print_fields*(struct trace_seq pass:[*]_s_, void pass:[*]_data_, int _size_, struct tep_event pass:[*]_event_);
+	void *tep_record_print_fields*(struct trace_seq pass:[*]_s_, struct tep_record pass:[*]_record_, struct tep_event pass:[*]_event_);
+	void *tep_record_print_selected_fields*(struct trace_seq pass:[*]_s_, struct tep_record pass:[*]_record_, struct tep_event pass:[*]_event_, int _ignore_mask_);
 	int *tep_print_num_field*(struct trace_seq pass:[*]_s_, const char pass:[*]_fmt_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, int _err_);
 	int *tep_print_func_field*(struct trace_seq pass:[*]_s_, const char pass:[*]_fmt_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, int _err_);
 
-- 
2.30.2

