Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2530FC433ED
	for <linux-trace-devel@archiver.kernel.org>; Sun, 11 Apr 2021 02:23:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D56A0610D1
	for <linux-trace-devel@archiver.kernel.org>; Sun, 11 Apr 2021 02:23:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234911AbhDKCXu convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 10 Apr 2021 22:23:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:35868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234680AbhDKCXt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 10 Apr 2021 22:23:49 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA999610CF;
        Sun, 11 Apr 2021 02:23:33 +0000 (UTC)
Date:   Sat, 10 Apr 2021 22:23:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: Bug in Test code
Message-ID: <20210410222331.24d04032@oasis.local.home>
In-Reply-To: <6b3b676e-b57c-5d05-142e-9e85e61a6ce5@gmail.com>
References: <6b3b676e-b57c-5d05-142e-9e85e61a6ce5@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 12 Apr 2021 06:43:44 +0530
sameeruddin shaik <sameeruddin.shaik8@gmail.com> wrote:

> hi,
> 
> Test: tracing options ...FAILED
>      1. tracefs-utest.c:746  - check_options_mask_empty(all)
>      2. tracefs-utest.c:747  - check_options_mask_empty(enabled)
>    Test: custom system directory ...FAILED
>      1. tracefs-utest.c:746  - check_options_mask_empty(all)
>      2. tracefs-utest.c:747  - check_options_mask_empty(enabled)
>    Test: ftrace marker ...trace-utest: ../nptl/pthread_mutex_lock.c:81: 
> __pthread_mutex_lock: Assertion `mutex->__data.__owner == 0' failed.
> Aborted (core dumped)
> 
> 
> Above tests are failing for me, what about you guys?
> 
> Do i have to give any command line options when running the test ?
> 
> I ran test like below
> 
> -----------------------
> 
> #./trace-utest
> 
> -----------------------
> 

Hi Sameer,

Thanks for the report. Yes, it is a bug in the tests. We did a last
minute change to have the options bitmask be stored in the instance and
it is immutable, but did not update the tests. The below patch should
fix it for you. Let us know if it does.

Thanks!

-- Steve

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 1f48e6f..3407202 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -679,7 +679,7 @@ out:
 	return ret;
 }
 
-static bool check_options_mask_empty(struct tracefs_options_mask *mask)
+static bool check_options_mask_empty(const struct tracefs_options_mask *mask)
 {
 	int i;
 
@@ -692,8 +692,9 @@ static bool check_options_mask_empty(struct tracefs_options_mask *mask)
 
 static void test_instance_tracing_options(struct tracefs_instance *instance)
 {
-	struct tracefs_options_mask *enabled;
-	struct tracefs_options_mask *all, *all_copy;
+	const struct tracefs_options_mask *enabled;
+	const struct tracefs_options_mask *all_copy;
+	const struct tracefs_options_mask *all;
 	enum tracefs_option_id i = 1;
 	char file[PATH_MAX];
 	const char *name;
@@ -745,9 +746,6 @@ static void test_instance_tracing_options(struct tracefs_instance *instance)
 	}
 	CU_TEST(check_options_mask_empty(all));
 	CU_TEST(check_options_mask_empty(enabled));
-
-	free(all);
-	free(enabled);
 }
 
 static void test_tracing_options(void)
