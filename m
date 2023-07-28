Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 218ECEB64DD
	for <linux-trace-devel@archiver.kernel.org>; Fri, 28 Jul 2023 22:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbjG1Wad (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 28 Jul 2023 18:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbjG1Wac (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 28 Jul 2023 18:30:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE45FE73
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 Jul 2023 15:30:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82F936220B
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 Jul 2023 22:30:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0FCC433C7;
        Fri, 28 Jul 2023 22:30:29 +0000 (UTC)
Date:   Fri, 28 Jul 2023 18:30:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stevie Alvarez <stevie.6strings@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH 5/5] histograms: Add struct traceeval unit tests
Message-ID: <20230728183027.14cc5ac6@rorschach.local.home>
In-Reply-To: <20230728190515.23088-5-stevie.6strings@gmail.com>
References: <20230728190515.23088-1-stevie.6strings@gmail.com>
        <20230728190515.23088-5-stevie.6strings@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 28 Jul 2023 15:04:40 -0400
Stevie Alvarez <stevie.6strings@gmail.com> wrote:

> From: "Stevie Alvarez (Google)" <stevie.6strings@gmail.com>
> 
> Add unit tests for traceeval_init(), traceeval_release(), and
> traceeval_compare() to check edge cases and ensure the interface is
> functional.

Just nits about extra white space that git showed me.

> 
> Signed-off-by: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
> ---
>  utest/.gitignore        |   1 +
>  utest/Makefile          |  35 +++++++
>  utest/eval-test.h       |  10 ++
>  utest/eval-utest.c      |  27 +++++
>  utest/traceeval-utest.c | 222 ++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 295 insertions(+)
>  create mode 100644 utest/.gitignore
>  create mode 100644 utest/Makefile
>  create mode 100644 utest/eval-test.h
>  create mode 100644 utest/eval-utest.c
>  create mode 100644 utest/traceeval-utest.c
> 
> diff --git a/utest/.gitignore b/utest/.gitignore
> new file mode 100644
> index 0000000..ca0ac10
> --- /dev/null
> +++ b/utest/.gitignore
> @@ -0,0 +1 @@
> +eval-utest
> diff --git a/utest/Makefile b/utest/Makefile
> new file mode 100644
> index 0000000..955f91e
> --- /dev/null
> +++ b/utest/Makefile
> @@ -0,0 +1,35 @@
> +# SPDX-License-Identifier: MIT
> +
> +include $(src)/scripts/utils.mk
> +
> +bdir := $(obj)/utest
> +eval_lib := $(obj)/lib/libtraceeval.a
> +
> +TARGETS = $(bdir)/eval-utest
> +
> +OBJS := eval-utest.o
> +OBJS += traceeval-utest.o
> +
> +LIBS += -lcunit				\
> +	-ldl				\
> +	$(eval_lib)
> +
> +OBJS := $(OBJS:%.o=$(bdir)/%.o)
> +
> +$(bdir):
> +	@mkdir -p $(bdir)
> +
> +$(OBJS): | $(bdir)
> +
> +$(bdir)/eval-utest: $(OBJS) $(eval_lib)
> +	$(Q)$(do_app_build)
> +
> +$(bdir)/%.o: %.c
> +	$(Q)$(call do_fpic_compile)
> +
> +-include .*.d
> +
> +test: $(TARGETS)
> +
> +clean:
> +	$(Q)$(call do_clean,$(TARGETS) $(bdir)/*.o $(bdir)/.*.d)
> diff --git a/utest/eval-test.h b/utest/eval-test.h
> new file mode 100644
> index 0000000..f3372e8
> --- /dev/null
> +++ b/utest/eval-test.h
> @@ -0,0 +1,10 @@
> +/* SPDX-License-Identifier: MIT */
> +/*
> + * Copyright (C) 2023 Google Inc, Stevie Alvarez <stevie.6strings@gmail.com>
> + */
> +#ifndef _EVAL_UTEST_H_
> +#define _EVAL_UTEST_H_
> +
> +void test_traceeval_lib(void);
> +
> +#endif /* _EVAL_UTEST_H_ */
> diff --git a/utest/eval-utest.c b/utest/eval-utest.c
> new file mode 100644
> index 0000000..771a0c4
> --- /dev/null
> +++ b/utest/eval-utest.c
> @@ -0,0 +1,27 @@
> +
> +// SPDX-License-Identifier: MIT
> +/*
> + * Copyright (C) 2023 Google Inc, Stevie Alvarez <stevie.6strings@gmail.com>
> + */
> +#include <stdio.h>
> +#include <stdlib.h>
> +
> +#include <CUnit/CUnit.h>
> +#include <CUnit/Basic.h>
> +
> +#include "eval-test.h"
> +
> +int main(int argc, char **argv)
> +{
> +	if (CU_initialize_registry() != CUE_SUCCESS) {
> +		printf("Test registry cannot be initialized\n");
> +		return EXIT_FAILURE;
> +	}
> +
> +	test_traceeval_lib();
> +
> +	CU_basic_set_mode(CU_BRM_VERBOSE);
> +	CU_basic_run_tests();
> +	CU_cleanup_registry();
> +	return EXIT_SUCCESS;
> +}
> diff --git a/utest/traceeval-utest.c b/utest/traceeval-utest.c
> new file mode 100644
> index 0000000..2bcb4b9
> --- /dev/null
> +++ b/utest/traceeval-utest.c
> @@ -0,0 +1,222 @@
> +// SPDX-License-Identifier: MIT
> +/*
> + * Copyright (C) 2023 Google Inc, Stevie Alvarez <stevie.6strings@gmail.com>
> + */
> +
> +#include <string.h>
> +#include <stdio.h>
> +#include <stdbool.h>
> +#include <CUnit/CUnit.h>
> +#include <CUnit/Basic.h>
> +
> +#include <histograms.h>
> +
> +#define TRACEEVAL_SUITE		"traceeval library"
> +#define TRACEEVAL_SUCCESS	0
> +#define TRACEEVAL_FAILURE	-1
> +#define TRACEEVAL_NOT_SAME	1
> +
> +/**
> + * Test traceeval_init(), traceeval_release(), and traceeval_compare() with
> + * NULL values.
> + */
> +void test_eval_null(void)
> +{
> +	// set up
> +	char *name = "test null";
> +	enum traceeval_data_type type = TRACEEVAL_TYPE_NONE;
> +	const struct traceeval_type test_data[] =  {
> +		{
> +			.type = TRACEEVAL_TYPE_NUMBER,
> +			.name = name
> +		},
> +		{
> +			.type = type,
> +			.name = NULL
> +		}
> +	};
> +
> +	// test init
> +	struct traceeval *result_null = traceeval_init(NULL, NULL);
> +	struct traceeval *result_key = traceeval_init(test_data, NULL);
> +	struct traceeval *result_val = traceeval_init(NULL, test_data);
> +	

Extra space at the end of the above.
> +	// analyze init
> +	CU_ASSERT(!result_null);
> +	CU_ASSERT(result_key != NULL);
> +	CU_ASSERT(!result_val);
> +
> +	// release
> +	traceeval_release(NULL);
> +	traceeval_release(result_key);
> +}
> +
> +/**
> + * Use provided data to test traceeval_init(), traceeval_compare(), and
> + * traceeval_release().
> + */
> +void test_eval_base(const struct traceeval_type *keys1,
> +		const struct traceeval_type *vals1,
> +		const struct traceeval_type *keys2,
> +		const struct traceeval_type *vals2,
> +		bool init_not_null1, bool init_not_null2,
> +		int compare_result)
> +{
> +	struct traceeval *init1;
> +	struct traceeval *init2;
> +	int result;
> +
> +	// test init
> +	init1 = traceeval_init(keys1, vals1);
> +	init2 = traceeval_init(keys2, vals2);
> +
> +	result = init1 != NULL;
> +	if (init_not_null1) {
> +		CU_ASSERT(result);
> +	} else {
> +		CU_ASSERT(!result);
> +	}
> +
> +	result = init2 != NULL;
> +	if (init_not_null2) {
> +		CU_ASSERT(result);
> +	} else {
> +		CU_ASSERT(!result);
> +	}
> +
> +	// test compare
> +	result = traceeval_compare(init1, init2);
> +	
> +	// analyze compare
> +	CU_ASSERT(result == compare_result);
> +	

Extra space above.

> +	// release
> +	traceeval_release(init1);
> +	traceeval_release(init2);
> +}
> +
> +/**
> + * Test traceeval_init(), traceeval_release(), and traceeval_compare() with
> + * TRACEEVAL_TYPE_NONE.
> + */
> +void test_eval_none(void)
> +{
> +	// set up
> +	char *name = "test none";
> +	char *name2 = "test none (some)";
> +	const struct traceeval_type test_data_none[] =  {
> +		{
> +			.type = TRACEEVAL_TYPE_NONE,
> +			.name = name
> +		}
> +	};
> +	const struct traceeval_type test_data_some[] =  {
> +		{
> +			.type = TRACEEVAL_TYPE_NUMBER,
> +			.name = name2
> +		},
> +		{
> +			.type = TRACEEVAL_TYPE_NONE,
> +			.name = NULL
> +		}
> +	};
> +
> +	test_eval_base(test_data_some, test_data_none, test_data_some,
> +			test_data_none, true, true, TRACEEVAL_SUCCESS);
> +	test_eval_base(test_data_none, test_data_none, test_data_some,
> +			test_data_none, false, true, TRACEEVAL_FAILURE);
> +	test_eval_base(test_data_none, test_data_none, test_data_none,
> +			test_data_none, false, false, TRACEEVAL_FAILURE);
> +}
> +
> +/**
> + * Test traceeval_init() and traceeval_release() with equivalent values.
> + */
> +void test_eval_same(void)
> +{
> +	// set up
> +	char *name = "test data";
> +	char *name2 = "test done";
> +	const struct traceeval_type test_data[] =  {
> +		{
> +			.type = TRACEEVAL_TYPE_NUMBER,
> +			.name = name
> +		},
> +		{
> +			.type = TRACEEVAL_TYPE_NONE,
> +			.name = name2
> +		}
> +	};
> +	

EXtra space above.

> +	test_eval_base(test_data, test_data, test_data, test_data, true, true,
> +			TRACEEVAL_SUCCESS);
> +}
> +
> +/**
> + * Test traceeval_init() and traceeval_release() with non-equivalent values.
> + */
> +void test_eval_not_same(void)
> +{
> +	const struct traceeval_type test_data1[] =  {
> +		{
> +			.type = TRACEEVAL_TYPE_NUMBER,
> +			.name = "test data 1"
> +		},
> +		{
> +			.type = TRACEEVAL_TYPE_NONE,
> +			.name = NULL
> +		}
> +	};
> +	const struct traceeval_type test_data2[] =  {
> +		{
> +			.type = TRACEEVAL_TYPE_NUMBER,
> +			.name = "test data 2"
> +		},
> +		{
> +			.type = TRACEEVAL_TYPE_NONE,
> +			.name = NULL
> +		}
> +	};
> +
> +	// type 1 key diff
> +	test_eval_base(test_data2, test_data1, test_data1, test_data1, true,
> +			true, TRACEEVAL_NOT_SAME);
> +	// type 1 data diff
> +	test_eval_base(test_data1, test_data2, test_data1, test_data1, true,
> +			true, TRACEEVAL_NOT_SAME);
> +	// type 2 key diff
> +	test_eval_base(test_data1, test_data1, test_data2, test_data1, true,
> +			true, TRACEEVAL_NOT_SAME);
> +	// type 2 data diff
> +	test_eval_base(test_data1, test_data1, test_data1, test_data2, true,
> +			true, TRACEEVAL_NOT_SAME);
> +}
> +
> +/**
> + * Tests the traceeval_init() and traceeval_release() functions.
> + */
> +void test_eval(void)
> +{
> +	test_eval_null();
> +	test_eval_none();
> +	test_eval_same();
> +	test_eval_not_same();
> +}
> +
> +/**
> + * Register tests with CUnit.
> + */
> +void test_traceeval_lib(void)
> +{
> +	CU_pSuite suite = NULL;
> +	

Extra space above.

> +	// set up suite
> +	suite = CU_add_suite(TRACEEVAL_SUITE, NULL, NULL);
> +	if (suite == NULL) {
> +		fprintf(stderr, "Suite %s cannot be created\n", TRACEEVAL_SUITE);
> +		return;
> +	}
> +
> +	// add tests to suite
> +	CU_add_test(suite, "Test traceeval alloc and release", test_eval);
> +}

-- Steve
