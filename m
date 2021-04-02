Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9F8DC433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Apr 2021 14:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82A8461041
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Apr 2021 14:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbhDBO4U (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Apr 2021 10:56:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229553AbhDBO4U (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Apr 2021 10:56:20 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E493461103;
        Fri,  2 Apr 2021 14:56:18 +0000 (UTC)
Date:   Fri, 2 Apr 2021 10:56:17 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com
Subject: Re: [PATCH] libtracefs: Unit test for the tracing filter API
Message-ID: <20210402105617.2bf3a438@gandalf.local.home>
In-Reply-To: <1617415260-19795-1-git-send-email-sameeruddin.shaik8@gmail.com>
References: <1617415260-19795-1-git-send-email-sameeruddin.shaik8@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat,  3 Apr 2021 07:31:00 +0530
Sameeruddin shaik <sameeruddin.shaik8@gmail.com> wrote:

> tracefs_function_filter();

Need some more information in the change log. What is this testing?

> 
> Signed-off-by: Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
> 
> diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
> index ed2693b..09e564f 100644
> --- a/utest/tracefs-utest.c
> +++ b/utest/tracefs-utest.c
> @@ -11,6 +11,7 @@
>  #include <time.h>
>  #include <dirent.h>
>  #include <ftw.h>
> +#include <errno.h>
>  
>  #include <CUnit/CUnit.h>
>  #include <CUnit/Basic.h>
> @@ -1020,6 +1021,80 @@ static void test_custom_trace_dir(void)
>  	free(dname);
>  }
>  
> +static int test_instance_filter(struct tracefs_instance *instance,
> +				const char **filters, const char *module,
> +				int flags)
> +{
> +	int ret;
> +	int i;
> +
> +	if (filters) {
> +		for (i = 0; filters[i]; i++) {
> +			ret = tracefs_function_filter(instance, filters[i],
> +						      module, flags);
> +			if (ret) {
> +				if (errno == EINVAL)
> +					printf("Filter %s did not match\n",
> +					       filters[i]);
> +				else
> +					printf("Failed writing %s\n",
> +					       filters[i]);
> +			}
> +		}
> +	} else {
> +		ret = tracefs_function_filter(instance, NULL, module, flags);
> +	}
> +	return ret;
> +}
> +
> +static void test_tracefs_function_filter(void)
> +{
> +	const char *filter[] = {"run_init_process", "ufs*", "^ext4.*$", NULL};

I ran this and it failed, because my box has no functions that start with
"ufs" nor "ext4" (I use an xfs file system).

You need to use core function names like "sched*" or "irq*", because ufs
and ext4 are modules that do not exist in all machines that this may be
executed on.

> +	const char *future_filter[] = {"write_dummy", "read_dummy", NULL};
> +	const char *future_module = "dummy";
> +	struct tracefs_instance *instance;
> +	const char *module = "btrtl";

I also do not have the btrtl module. You may need to see what modules are
loaded (reading /proc/modules will help you there).

> +	int ret;
> +
> +	instance = tracefs_instance_create(TEST_INSTANCE_NAME);
> +	CU_TEST(instance != NULL);
> +
> +	ret = tracefs_function_filter(instance, NULL, NULL,
> +				      TRACEFS_FL_RESET | TRACEFS_FL_CONTINUE);
> +	if (ret) {
> +		printf("Failed to reset the filter\n");

Should the above be a CU_TEST failure?

> +		if (ret < 0)
> +			tracefs_function_filter(instance, NULL, NULL, 0);
> +	}
> +	/* Test string, kernel glob and regex for specific_instance*/
> +	ret = test_instance_filter(instance, filter, NULL, TRACEFS_FL_CONTINUE);
> +	CU_ASSERT(ret == 0);
> +	/* Test Module only with no filters*/
> +	ret = test_instance_filter(instance, NULL, module, TRACEFS_FL_CONTINUE);
> +	CU_ASSERT(ret == 0);
> +	ret = test_instance_filter(instance, future_filter, future_module,
> +				   TRACEFS_FL_CONTINUE | TRACEFS_FL_FUTURE);
> +	CU_ASSERT(ret == 0);
> +	tracefs_function_filter(instance, NULL, NULL, 0);

Should the above result also be tested?

> +
> +	ret = tracefs_function_filter(NULL, NULL, NULL,
> +				      TRACEFS_FL_RESET | TRACEFS_FL_CONTINUE);
> +	if (ret) {

And here too.

> +		printf("Failed to reset the filter\n");
> +		if (ret < 0)
> +			tracefs_function_filter(instance, NULL, NULL, 0);
> +	}
> +	/* Test top instance*/
> +	ret = test_instance_filter(NULL, filter, NULL, TRACEFS_FL_CONTINUE);
> +	CU_ASSERT(ret == 0);
> +	ret = test_instance_filter(NULL, NULL, module, TRACEFS_FL_CONTINUE);

As I stated above, I don't have the module you picked, and will most
definitely fail this test as FUTURE is not set.

> +	CU_ASSERT(ret == 0);
> +	ret = test_instance_filter(NULL, future_filter, future_module,
> +				   TRACEFS_FL_CONTINUE | TRACEFS_FL_FUTURE);
> +	CU_ASSERT(ret == 0);
> +	tracefs_function_filter(NULL, NULL, NULL, 0);
> +}

Anyway, this is a good start.

Thanks!

-- Steve

> +
>  static int test_suite_destroy(void)
>  {
>  	tracefs_instance_destroy(test_instance);
> @@ -1075,4 +1150,6 @@ void test_tracefs_lib(void)
>  		    test_tracing_options);
>  	CU_add_test(suite, "custom system directory",
>  		    test_custom_trace_dir);
> +	CU_add_test(suite, "Set Filter API",
> +		    test_tracefs_function_filter);
>  }

