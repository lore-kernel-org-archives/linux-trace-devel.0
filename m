Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76DB3C4708E
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Jan 2023 17:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234990AbjADR1D (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Jan 2023 12:27:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240094AbjADR07 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Jan 2023 12:26:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53156F03F
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jan 2023 09:26:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E375E617AA
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jan 2023 17:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FCC7C433F0;
        Wed,  4 Jan 2023 17:26:57 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1pD7XU-000bsR-0o;
        Wed, 04 Jan 2023 12:26:56 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Daniel Wagner <dwagner@suse.de>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/2] libtraceevent: Remove tep_find_function{_address}() from libtraceevent-func_apis.txt
Date:   Wed,  4 Jan 2023 12:26:55 -0500
Message-Id: <20230104172655.145516-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230104172655.145516-1-rostedt@goodmis.org>
References: <20230104172655.145516-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When a man page has more than 9 APIs described in it, asciidoc starts to
complain. As there were more functions being added to the function tep
interface, the man page that described the function interface was split to
have the "find" functions in a separate man page. But two functions were
left behind in the old libtraceevent-func_apis.txt man page:

  tep_find_function()
  tep_find_function_address()

This causes issue because it becomes ambiguous to which man page to read,
and one may become out of date. Remove the description from the
libtraceevent-func_apis.txt as they are described in
libtraceevent-func_find.txt man page.

Link: https://lore.kernel.org/linux-trace-devel/20221224153225.ojre2c3fxktfxtj2@carbon.lan/

Fixes: dd8094ac7252 ("tools lib traceevent: Man pages for function related libtraceevent APIs")
Reported-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtraceevent-func_apis.txt | 26 ++++-------------------
 1 file changed, 4 insertions(+), 22 deletions(-)

diff --git a/Documentation/libtraceevent-func_apis.txt b/Documentation/libtraceevent-func_apis.txt
index a465d63ff5b5..1b836a12e5ce 100644
--- a/Documentation/libtraceevent-func_apis.txt
+++ b/Documentation/libtraceevent-func_apis.txt
@@ -3,10 +3,8 @@ libtraceevent(3)
 
 NAME
 ----
-tep_find_function, tep_find_function_address, tep_set_function_resolver,
-tep_reset_function_resolver, tep_register_function, tep_register_print_string,
-tep_get_function_count -
-function related tep APIs
+tep_set_function_resolver, tep_reset_function_resolver, tep_register_function, tep_register_print_string,
+tep_get_function_count - function related tep APIs
 
 SYNOPSIS
 --------
@@ -17,8 +15,6 @@ SYNOPSIS
 typedef char pass:[*](*tep_func_resolver_t*)(void pass:[*]_priv_, unsigned long long pass:[*]_addrp_, char pass:[**]_modp_);
 int *tep_set_function_resolver*(struct tep_handle pass:[*]_tep_, tep_func_resolver_t pass:[*]_func_, void pass:[*]_priv_);
 void *tep_reset_function_resolver*(struct tep_handle pass:[*]_tep_);
-const char pass:[*]*tep_find_function*(struct tep_handle pass:[*]_tep_, unsigned long long _addr_);
-unsigned long long *tep_find_function_address*(struct tep_handle pass:[*]_tep_, unsigned long long _addr_);
 int *tep_register_function*(struct tep_handle pass:[*]_tep_, char pass:[*]_name_, unsigned long long _addr_, char pass:[*]_mod_);
 int *tep_register_print_string*(struct tep_handle pass:[*]_tep_, const char pass:[*]_fmt_, unsigned long long _addr_);
 int *tep_get_function_count*(struct tep_handle *_tep_)
@@ -38,8 +34,8 @@ the name of the function and its module (if any) in _modp_.
 The *tep_set_function_resolver()* function registers _func_ as an alternative
 kernel functions resolver. The _tep_ argument is trace event parser context.
 The _priv_ argument is a custom context of the _func_ function. The function
-resolver is used by the APIs *tep_find_function()*,
-*tep_find_function_address()*, and *tep_print_func_field()* to resolve
+resolver is used by the APIs *tep_find_function*(3),
+*tep_find_function_address*(3), and *tep_print_func_field()* to resolve
 a function address to a function name.
 
 The *tep_reset_function_resolver()* function resets the kernel functions
@@ -51,14 +47,6 @@ These APIs can be used to find function name and start address, by given
 address. The given address does not have to be exact, it will select
 the function that would contain it.
 
-The *tep_find_function()* function returns the function name, which contains the
-given address _addr_. The _tep_ argument is the trace event parser context.
-
-The *tep_find_function_address()* function returns the function start address,
-by given address _addr_. The _addr_ does not have to be exact, it will select
-the function that would contain it. The _tep_ argument is the trace event
-parser context.
-
 The *tep_register_function()* function registers a function name mapped to an
 address and (optional) module. This mapping is used in case the function tracer
 or events have "%pS" parameter in its format string. It is common to pass in
@@ -84,12 +72,6 @@ RETURN VALUE
 The *tep_set_function_resolver()* function returns 0 in case of success, or -1
 in case of an error.
 
-The *tep_find_function()* function returns the function name, or NULL in case
-it cannot be found.
-
-The *tep_find_function_address()* function returns the function start address,
-or 0 in case it cannot be found.
-
 The *tep_register_function()* function returns 0 in case of success. In case of
 an error -1 is returned, and errno is set to the appropriate error number.
 
-- 
2.35.1

