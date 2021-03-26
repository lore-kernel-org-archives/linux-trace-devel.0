Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,
	DATE_IN_FUTURE_12_24,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26FE3C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 00:44:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3680619BB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 00:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239352AbhCYAnb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 20:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239203AbhCYAnQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 20:43:16 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C8EC06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 17:43:15 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id l3so235795pfc.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 17:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=yM2TAoCFfaFBWlU9pUQR7TRV2kF4/qDH0Stup3Ue9dE=;
        b=EIWFJGrAJasCSuKh+YHOUnK9X0a4u6kyUDQ3TimzCHWoVY9CWHU88UMqlwUoQ4iUvL
         X+wIi6RAq7YnR5wHimk5v75B/EfDZYSLVqp61Erd1bMmWhr9n57jzzDVDyk0xM4nZ8ZZ
         pYhPMVUgHEzPLaD41xwYE7SusieDt7TcKJJkIodaclPRHGZfahCimK2VRskbE/aHFRNU
         vtW9p7IwzqMk2TgWV9hi/ovN66/kV9e4XL2RGc6/hIfp8nQfq7LapJX53JMiPTgLJVcf
         IBA55e43yfT+jct4HMItVIY0hTYW84wjNKyPTAThMAzpmr9qlNL+3EwySPUnJMMunjcI
         DQng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yM2TAoCFfaFBWlU9pUQR7TRV2kF4/qDH0Stup3Ue9dE=;
        b=i1I8gAb5h1TuxU2GSLjUQ4PjtfIJA2pjObxR3rFEqaJ14rHzw3x5KjDGcFE1OBnSK2
         Wst19wHcSrQ24y3O8TOh4kzOB8EQ80q56PMDRqGza9Vd2aB9BAHQMfj+HE6hjC69TzRr
         TOcCdZLsC7pkG5Lv3qodWr6QpQtua6qENNO9uSayl0NdVRhGSskCoqi68Nlk71waq+vo
         oFy5zB00yTydg5KkxPudNofmXt9Fxz0Js+ClW5EF3sbdrRKTeLsBITGsGs0BxcvMKRqC
         voWpLA9X1l0MPv5O3tFU81qzQJdxpxgT4gc3bmrCeEmYrzvFpwUuPUo4vMsoZ9AoT+CZ
         lLuQ==
X-Gm-Message-State: AOAM533JCNSEqboM21JAy1uqHU97a+Tdq5nWHoCB0VnjfkMB0dECLPat
        CEkGK4P+iR9/PBTyJTxr3jA=
X-Google-Smtp-Source: ABdhPJyHw/wN8EHTG2yyeCCUojrxpNXeB/HgBxwUo4jH1jp47MR9I3GInU6avs+9JgIr4DM7PjUR8w==
X-Received: by 2002:a62:764c:0:b029:1ef:20d2:b44 with SMTP id r73-20020a62764c0000b02901ef20d20b44mr5368792pfc.45.1616632995493;
        Wed, 24 Mar 2021 17:43:15 -0700 (PDT)
Received: from localhost.localdomain ([27.6.175.206])
        by smtp.gmail.com with ESMTPSA id p3sm3341799pgi.24.2021.03.24.17.43.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Mar 2021 17:43:15 -0700 (PDT)
From:   Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com,
        Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: [PATCH] libtracefs: Document function_filter API
Date:   Fri, 26 Mar 2021 06:13:40 +0530
Message-Id: <1616719420-6747-1-git-send-email-sameeruddin.shaik8@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added documentation for the below API:
tracefs_function_filter()

Signed-off-by: Sameeruddin shaik <sameeruddin.shaik8@gmail.com>

diff --git a/Documentation/libtracefs-function-filter.txt b/Documentation/libtracefs-function-filter.txt
new file mode 100644
index 0000000..34d8979
--- /dev/null
+++ b/Documentation/libtracefs-function-filter.txt
@@ -0,0 +1,120 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_function_filter - Function to limit kernel functions that are traced
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
+This function can be used to limit the Linux kernel functions that were
+traced by the function and function-graph tracers
+
+It will take
+_instance_ , that can be NULL for the top level tracing.
+_filters_, which is an array of the strings that represent a list of filters that should
+be applied to define what functions are to be traced and The array must end
+with a NULL pointer.
+_module_ , name of the module to be traced.
+_reset_ if set will clear the current set of filters and then apply the
+filter list, otherwise the list of filters are added to the current set of
+filters,
+_errs_, is a pointer to an array of strings, which will be allocated if
+any of filters fail to match any available function, If _errs_ is NULL, it will
+be ignored.
+
+returns 0  on success, 1 or -x (where x is an integer) on error.
+
+RETURN VALUE
+------------
+return 0 on success, if there is error, it will return 1 for general errors or
+negative number -x(x denotes number of failed filters), if there are any failed filters.
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

