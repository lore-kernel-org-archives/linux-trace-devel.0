Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0488EB64DD
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Aug 2023 16:27:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbjHCQ1v (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 3 Aug 2023 12:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236501AbjHCQ1u (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 3 Aug 2023 12:27:50 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7889C3AA9
        for <linux-trace-devel@vger.kernel.org>; Thu,  3 Aug 2023 09:27:47 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id e9e14a558f8ab-3490a1f8ae0so4174815ab.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 03 Aug 2023 09:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691080067; x=1691684867;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6QqtAl0VPjk7s4w/42sevsxEvvfeqwP7pzghDUK8Q/Y=;
        b=ESf35f7FsgSYE87zo4A4V66pSLPorj+PwLr+EZJtu+m/7EdqShjHI96ZCMC0geR32l
         3BcDEM/E0zvdnT/Ow7XlezjeFaBIghmHR0h12KqUU07q7qrP43v7g+AAJeHnHd9Pn7AP
         y91JvGYzVHQxBXfd30GnrqExxEFT5d3322YTWGOUCveKGDJvI9TqiAu9PHStpzeiS0Hy
         njIdxyqtDD+XZsaUBbytBMB4IX2oqRKF3kynHXwL6ITNXWeiaxX89lQv4s06KK2htimq
         vmrfrXLxyREDa1BFDZzBTiA94EXGCIAOuNSLK2bfDjtUhhkl4+uygtKc1NRcegMoyewl
         L6Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691080067; x=1691684867;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6QqtAl0VPjk7s4w/42sevsxEvvfeqwP7pzghDUK8Q/Y=;
        b=Gdc+Y6pNV9trEYW5QeYjMGc5+l/QmerhHFa30nlI1d+Dt9A+7UmkG6k3YAkNAHPpHU
         +EKly6TBEEDxbXh0DNatirl6z6ttjW4D61Iye3yv7O7Fxp0lFjWvq7xgWjve7wBHIPmE
         yy2HK8vu8T82wPVQDywArIcOacEZN04k6spLbTRkiSnM9FBTPFPeXhnq/etJmWwfvoNs
         nHffYHjA3wUmMwzsos8T27lN9VlTInoaB+qriBQ2n3D42JVJuu4bW31M/k+rBAW324oV
         bHsaxkRaSWHdSVZxcTC/m3kHnUCXsOgnMNYSRzzfswI4CFZDoIhXIx1BTDvH56ZSbwer
         PauA==
X-Gm-Message-State: ABy/qLb503WoO8OglTDluZcpfxJJzGt9OBcGnQlLJ9yji9kIXtuYdQQz
        ZldijVJAPvIBjMWotEZU2ue53A==
X-Google-Smtp-Source: APBJJlE3tZl1LqUnzhmB+HFqxKgVCvmCs5dL8q1I77ybcnaumowjTpq/U+V6NIUcZd20WYpwl2VYHw==
X-Received: by 2002:a05:6e02:1bcc:b0:33a:a6de:65be with SMTP id x12-20020a056e021bcc00b0033aa6de65bemr18532973ilv.21.1691080066658;
        Thu, 03 Aug 2023 09:27:46 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:c78b:f199:f5c0:23a2])
        by smtp.gmail.com with ESMTPSA id ee15-20020a056638292f00b004290985a1efsm5503jab.43.2023.08.03.09.27.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 09:27:45 -0700 (PDT)
Date:   Thu, 3 Aug 2023 10:27:42 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Stevie Alvarez <stevie.6strings@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 5/5] histograms: Add struct traceeval unit tests
Message-ID: <20230803162742.GA3575843@google.com>
References: <20230728190515.23088-1-stevie.6strings@gmail.com>
 <20230728190515.23088-5-stevie.6strings@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230728190515.23088-5-stevie.6strings@gmail.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Jul 28, 2023 at 03:04:40PM -0400, Stevie Alvarez wrote:
> From: "Stevie Alvarez (Google)" <stevie.6strings@gmail.com>
> 
> Add unit tests for traceeval_init(), traceeval_release(), and
> traceeval_compare() to check edge cases and ensure the interface is
> functional.
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

All functions except test_traceeval_lib() should be static.

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
			.type = TRACEEVAL_TYPE_NONE,

and you can get rid of the 'type' variable.

> +			.name = NULL
> +		}
> +	};
> +
> +	// test init
> +	struct traceeval *result_null = traceeval_init(NULL, NULL);
> +	struct traceeval *result_key = traceeval_init(test_data, NULL);
> +	struct traceeval *result_val = traceeval_init(NULL, test_data);
> +	
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

        char *name2 = "test none";
        ?

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

nit: maybe just inline all the names in other test functions, like you have in
this one?  Saves some variables & is more readable.

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
> -- 
> 2.41.0
> 
