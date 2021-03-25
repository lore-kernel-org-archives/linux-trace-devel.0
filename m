Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,
	DATE_IN_FUTURE_12_24,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3501AC433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 16:32:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F18461A0E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 16:32:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbhCXQbk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 12:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236012AbhCXQbi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 12:31:38 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA62C061763
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 09:31:37 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id v8so8224174plz.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 09:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=dFXGzHfZJtki7/XvdMmhH29M6v4lZLeH+Zg+LONjJU4=;
        b=E6qQv5Kpd9YeHHY5qX9ZwHz7TmtCAwO7kimphkTnOUsZ1CXK/a3Nbb//2wHHCDXfOd
         p8p6XoCShYRgFJlqsgg6cfoJRGoQqF2hWzPnRstdZR+yy7B52xfMPUYsFWu/E2HOHLcv
         ma6EKUtcRIDISPwxkAIO5otTACpTjJB83e8Yh0/BgNr40ZjvO2vzEXp8L25N3Nf6LnZW
         mopVi4xArBw7OtF4zqWrC/dTZbqwnX+GEv3TUgP5Epyc1Bp8D9nzhtR1JcKnkKFNUrnn
         pIFA3rM4H7kuCkHlVdaKWsxziTc6SknVMAPrQkYAq8kicH74xAown0a8oD0O43/wRA25
         XCVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dFXGzHfZJtki7/XvdMmhH29M6v4lZLeH+Zg+LONjJU4=;
        b=Azwo9eYTKUrrqQuwgTh29XrjUnwBHyf8jQVN27GfWTRAEeUV1cpynqy6ZselEncvsD
         LAOzYy2XXkgEMyKH9sjrkiOdrMd9vsu//YJtMy0plH0Hz6K6ETBK5adWMTHnz9rJbj+o
         w9rvZBohwb7Lb2vLBok66i2X9wYnc+YxTq70cQM+98p8hmcjZM5s+RXdkKyV3sJWNU3u
         0eSOVpa4NuXm+U5meEaQfnckKctZwe/3j4LfTmpz9VEeaslgoaMiDjQyvOnLJOOGJGws
         J4HJvz04UVmKbYaKuY6GJJoH9CzO3FKkj+6+Yh/ertUJ05YKR0WexPX6o1ByLAYAA0PT
         0Cgg==
X-Gm-Message-State: AOAM533ehBbInHkRUFv+bmA5v73+VgUf024pXfjRHXewfpz1Oe/nftKK
        jIBwwZuh3ZOCRCTlJioyzSI4DGA2Jy2PJNu7
X-Google-Smtp-Source: ABdhPJy3G0bKhPKwF0Wg/ZBRdrkC6sqB1DfCED273b62Nqdhmkk60WckRyjqGCCGQ5Kbnh81SU9bLQ==
X-Received: by 2002:a17:90a:7182:: with SMTP id i2mr4238245pjk.111.1616603497436;
        Wed, 24 Mar 2021 09:31:37 -0700 (PDT)
Received: from localhost.localdomain ([27.6.99.135])
        by smtp.gmail.com with ESMTPSA id z3sm3144336pff.40.2021.03.24.09.31.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Mar 2021 09:31:37 -0700 (PDT)
From:   Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com,
        Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: [PATCH] libtracefs: Document function_filter API
Date:   Thu, 25 Mar 2021 22:01:30 +0530
Message-Id: <1616689890-18853-1-git-send-email-sameeruddin.shaik8@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added documentation for the below API:
tracefs_function_filter()

Signed-off-by: Sameeruddin shaik <sameeruddin.shaik8@gmail.com>

diff --git a/Documentation/libtracefs-function-filter.txt b/Documentation/libtracefs-function-filter.txt
new file mode 100644
index 0000000..08eece7
--- /dev/null
+++ b/Documentation/libtracefs-function-filter.txt
@@ -0,0 +1,116 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_function_filter -  Function to write to set_ftrace_filter
+file of specific instance or top tracing instance
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+int tracefs_function_filter(struct tracefs_instance *instance, const char **filters, const char *module, bool reset, const char ***errs);
+--
+
+DESCRIPTION
+-----------
+This Function can be used to write to set_ftrace_file in the trace
+filesystem, which will limit the trace to only those functions,
+which were written in the file.
+
+It will take take _instance_argument, that can be NULL for the
+top level tracing, _filters_, which is nothing but the array of the
+strings to write into the set_ftrace_filter file ,_module_ , name of the
+module to be traced, _reset_, to reset or append the filters to file
+ and _errs_ which is again an array of failed filters, which can be NULL
+ if failed filters are not of concern, and  returns 0  on successful write,
+ 1 or -x (where x is an integer) on error.
+
+RETURN VALUE
+------------
+tracefs_function_filter will return 0 on successful write to file, if there
+is error, it will return 1 for general errors or negative number -x(x denotes
+number of failed filters), if there are any failed filters.
+
+In case of negative return value, errs have to be checked and must be freed
+using the free()
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <tracefs.h>
+
+#define INST "dummy"
+
+const char *filters[] = { "run_init_process", "try_to_run_init_process", "dummy1", NULL };
+
+int main(int argc, char *argv[])
+{
+	struct tracefs_instance *inst = tracefs_instance_create(INST);
+	const char **errs = NULL;
+	bool reset = 1;
+	int ret;
+	int i = 0;
+
+	if (!inst) {
+	   /* Error creating new trace instance*/
+	   }
+
+	ret = tracefs_function_filter(inst, filters, NULL, reset, &errs);
+
+	if (ret < 0 && errs) {
+	   	while (errs[i])
+		      printf("%s\n", errs[i++]);
+	      }
+
+	tracefs_instance_free(inst);
+	tracefs_instance_destroy(inst);
+	free(errs);
+	return 0;
+}
+--
+
+FILES
+-----
+[verse]
+--
+*tracefs.h*
+	Header file to include in order to have access to the library APIs.
+*-ltracefs*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+_libtracefs(3)_,
+_libtraceevent(3)_,
+_trace-cmd(1)_
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>
+*sameeruddin shaik* <sameeruddin.shaik8@gmail.com>
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtracefs is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
+
+COPYING
+-------
+Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
-- 
2.7.4

