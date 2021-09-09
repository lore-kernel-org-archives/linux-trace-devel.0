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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6690AC4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Sep 2021 08:06:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E1FE61132
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Sep 2021 08:06:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbhIIIID (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Sep 2021 04:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbhIIIIC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Sep 2021 04:08:02 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF074C061757
        for <linux-trace-devel@vger.kernel.org>; Thu,  9 Sep 2021 01:06:52 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 9so1453411edx.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Sep 2021 01:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7Jh35QPcE8A+X/dKjCSF429kpZHz2xl4nXSql3ZOWHs=;
        b=j7U6NmOaC2BaTnekLhssENJyCPLHn4qnqWLKIpJKLkzF4RGR/0Nwln1EZEaYsARS35
         nEyqLCy2r3alvERPJlGy7rZPr8kOMCtM2RSYvIdhgc1D/4fPCIbv0TKyG1Pj97kzCqiF
         s2G+ATuXGCr2Sa/VXvbiqTWyztTKGBxFH2++FyxBGi8PGaBlo3akVmR2ntNjJfOQVSoT
         icAuOzlZE1pXD4U3LevCkSqlXbT3Ojl0cqAsFTJOOl3ZsiFA1eKrW4o1zhzgsIz0XKql
         YYm/lsgKXkfepOwZLGQbteeD3RreV3yojEzrqCE/6snyVQd74LlTEu2PpUe8bT9OwTcA
         1xDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7Jh35QPcE8A+X/dKjCSF429kpZHz2xl4nXSql3ZOWHs=;
        b=zw1COTniN1qCriyitFofnGH+r5CCWCPF4cL6oi1LL2CG1k1tUaD42RLyPEiGw104vU
         JgQiyqBC058N5J0hprz5+fzL6zEaV2lCt00a2ZH/qBmTmvye7xGn2t6SDRSCK33119eb
         cjiLeZtg2stwqQggmpGgog6zz8h+OGQNKrw37QPATQNRFQb8UKnRLTtQZhK3J6J2K7JV
         faw0wxuSXe8eXheWN/lNdiPrKzUKUl7ToTgUh61uLW2TQ71FIMqWF+68T1jwGvLN3uZ9
         jvJS7WaKN2+I+DxyTvpcqoOOMtqmZ0mHkaWmqFTPjenvnlbSfWK6DaNkmDANUyvUUZWg
         +Faw==
X-Gm-Message-State: AOAM533sdjrkR22Hekp1ru2Yt0vppp7dlOPQCq4Z8fE8rOrhT5FIxjYZ
        IGQcpchONpCdOAeKjhQDLMy/aVDjvv8=
X-Google-Smtp-Source: ABdhPJxY+3Ne2lIg8huyLgWLQrbh3vrOSM1+dgqsAU5wn+FxDpqBcVX2wNpV5lRGOkEyYGembTWxAw==
X-Received: by 2002:a05:6402:1438:: with SMTP id c24mr1404247edx.22.1631174811623;
        Thu, 09 Sep 2021 01:06:51 -0700 (PDT)
Received: from crow.. ([95.87.199.93])
        by smtp.gmail.com with ESMTPSA id l8sm491821ejn.103.2021.09.09.01.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 01:06:51 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v8 2/2] libtraceevent: Add documentation for the new printing APIs
Date:   Thu,  9 Sep 2021 11:06:38 +0300
Message-Id: <20210909080638.259024-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909080638.259024-1-y.karadz@gmail.com>
References: <20210909080638.259024-1-y.karadz@gmail.com>
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
index 2c2cf6c..c201c13 100644
--- a/Documentation/libtraceevent-field_print.txt
+++ b/Documentation/libtraceevent-field_print.txt
@@ -3,7 +3,7 @@ libtraceevent(3)
 
 NAME
 ----
-tep_print_field, tep_print_fields, tep_print_num_field, tep_print_func_field -
+tep_print_field, tep_print_fields, tep_print_num_field, tep_print_func_field, tep_record_print_fields, tep_record_print_selected_fields -
 Print the field content.
 
 SYNOPSIS
@@ -17,6 +17,8 @@ void *tep_print_field*(struct trace_seq pass:[*]_s_, void pass:[*]_data_, struct
 void *tep_print_fields*(struct trace_seq pass:[*]_s_, void pass:[*]_data_, int _size_, struct tep_event pass:[*]_event_);
 int *tep_print_num_field*(struct trace_seq pass:[*]_s_, const char pass:[*]_fmt_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, int _err_);
 int *tep_print_func_field*(struct trace_seq pass:[*]_s_, const char pass:[*]_fmt_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, int _err_);
+void *tep_record_print_fields*(struct trace_seq pass:[*]_s_, struct tep_record pass:[*]_record_, struct tep_event pass:[*]_event_);
+void *tep_record_print_selected_fields*(struct trace_seq pass:[*]_s_, struct tep_record pass:[*]_record_, struct tep_event pass:[*]_event_, int _select_mask_);
 --
 
 DESCRIPTION
@@ -49,6 +51,13 @@ function. The function name (if found) and its address are printed in the _s_,
 according to the given format string _fmt_. If the argument _err_ is non-zero,
 and an error occures - it is printed in _s_.
 
+The _tep_record_print_fields()_ prints the field's name followed by its value
+for all record's field.
+
+The _tep_record_print_selected_fields()_ prints the field's name followed by
+its value for selected subset of record field. The fields to be printed are
+defined by the _select_mask_ bit mask.
+
 RETURN VALUE
 ------------
 The _tep_print_num_field()_ and _tep_print_func_field()_ functions return 1
diff --git a/Documentation/libtraceevent.txt b/Documentation/libtraceevent.txt
index d42b5c9..01014b7 100644
--- a/Documentation/libtraceevent.txt
+++ b/Documentation/libtraceevent.txt
@@ -80,6 +80,8 @@ Event fields printing:
 	void *tep_print_fields*(struct trace_seq pass:[*]_s_, void pass:[*]_data_, int _size_, struct tep_event pass:[*]_event_);
 	int *tep_print_num_field*(struct trace_seq pass:[*]_s_, const char pass:[*]_fmt_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, int _err_);
 	int *tep_print_func_field*(struct trace_seq pass:[*]_s_, const char pass:[*]_fmt_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, int _err_);
+	void *tep_record_print_fields*(struct trace_seq pass:[*]_s_, struct tep_record pass:[*]_record_, struct tep_event pass:[*]_event_);
+	void *tep_record_print_selected_fields*(struct trace_seq pass:[*]_s_, struct tep_record pass:[*]_record_, struct tep_event pass:[*]_event_, int _select_mask_);
 
 Event fields finding:
 	struct tep_format_field pass:[*]*tep_find_common_field*(struct tep_event pass:[*]_event_, const char pass:[*]_name_);
-- 
2.30.2

