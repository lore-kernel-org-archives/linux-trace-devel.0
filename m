Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 962EFC433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 11:25:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50E22611CE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 11:25:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232492AbhDZL0e (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Apr 2021 07:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232364AbhDZL0e (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Apr 2021 07:26:34 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C623BC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Apr 2021 04:25:52 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id a12so38727000pfc.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Apr 2021 04:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XbHiY7zKDa23ZuMD35LfVkUOFyJBWgJlEXpkpDMkvs8=;
        b=hTLUCBZMNnd7CAW8sCp6gbMYX5KHxiKTvfSO/EnBzon5HABfBUrVy1OLyOE8248GS2
         lHPKN7TgeAxFUb/2z+Dt95GOlZkdSCDCdT5psq7iEszPYsSKXjEvF856GUGPkGzgkoKn
         53dNNtFRqXB3sr1XQPOC3XjoiTB9eXkHc2VlqU1K28pRONDv+oeTHtvrpL2kndmXin8Z
         37XFrwNxO6M+7aWV+cILxCwX14l8upyiy6Pnf//ejZ2YZC+l0Q8nzAFgw2PryGouySOU
         rSb6TJj0dllp+JbRo0wvmbsvmZymnz3Y5FQo0mfY9tbEOpoOsUpf59plDWUhwWduaNCV
         T6ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XbHiY7zKDa23ZuMD35LfVkUOFyJBWgJlEXpkpDMkvs8=;
        b=oET1eNfs0xnL7eHSGgOUIimgSjtvbcF0h73qMlqDEKOKnmNOAnZkPW47pjhEFJLOj4
         TyGldxlkYzmmcikqx3cWEwjkn4g1eyz7wrIQmYGl5/6caKrX5ToIF5Fo0FToczIe7ZI5
         58DDIhrEyK+24J9VIABMCC8DgnXs+hSKAiOKWXwWcPZWV5rmrGbPGYoq/xlze3BXB3vz
         ZqgfrWckvY7TAxiXFjtaJS14WnA5MwllAj0p26gQHhVxvSkubvFDmvAj2hpH1/OXaQcI
         yOXoLFD/oKFsHW+G2cGglB8sMxMLxq+t32SqsmRp31YRPcK3jYp08er0UE4Ts82uD4ZF
         p88Q==
X-Gm-Message-State: AOAM531bXsPL5Gd7NapXOb069eQWETbjP+ZR8tdCKIZGW5mZ1xgOlIp1
        kklPzZrd2QlpFiCTa8PJC3iCBXeKJFWrNdiSILVisvgmt2rxIw==
X-Google-Smtp-Source: ABdhPJywUt2NAwesY1+K9t4GlQHV0Li+DF5bg8NvESFeqbwnbcQCbfNLziV66tT/mFIHoxpdvJGZz4cdRvbglICu9dc=
X-Received: by 2002:a62:3892:0:b029:250:4fac:7e30 with SMTP id
 f140-20020a6238920000b02902504fac7e30mr17346094pfa.81.1619436352270; Mon, 26
 Apr 2021 04:25:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210423035438.2221760-1-irogers@google.com>
In-Reply-To: <20210423035438.2221760-1-irogers@google.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 26 Apr 2021 14:25:35 +0300
Message-ID: <CAPpZLN4Ny2BkpfuBczA-Bs9-Nzf5md_CuqbEHgDYUD4pggtvjw@mail.gmail.com>
Subject: Re: [PATCH 1/3] libtracefs utest: Silence string-plus-int warnings
To:     Ian Rogers <irogers@google.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Apr 23, 2021 at 6:54 AM Ian Rogers <irogers@google.com> wrote:
>
> Fix warnings of the form:
>
> utest/tracefs-utest.c:476:35: error: adding 'int' to a string does not append to the string [-Werror,-Wstring-plus-int]
>         CU_TEST(strstr(kprobes, KPROBE_1 + 2) != NULL);
>         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~
>

Hi Ian,
Thanks for testing and sending this patch. What
compiler/version/options you are using to get these warnings ?
The whole patchset looks good to me.

Acked-by: Tzvetomir Stoyanov <tz.stoyanov@gmail.com>



> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  utest/tracefs-utest.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
> index edb3a3d..c5efd5f 100644
> --- a/utest/tracefs-utest.c
> +++ b/utest/tracefs-utest.c
> @@ -453,21 +453,21 @@ static void test_instance_file(void)
>         CU_TEST(ret == strlen(KPROBE_1));
>         kprobes = tracefs_instance_file_read(NULL, KPROB_EVTS, &size);
>         CU_TEST(kprobes != NULL);
> -       CU_TEST(strstr(kprobes, KPROBE_1 + 2) != NULL);
> +       CU_TEST(strstr(kprobes, &KPROBE_1[2]) != NULL);
>         free(kprobes);
>
>         ret = tracefs_instance_file_append(NULL, KPROB_EVTS, KPROBE_2);
>         CU_TEST(ret == strlen(KPROBE_2));
>         kprobes = tracefs_instance_file_read(NULL, KPROB_EVTS, &size);
>         CU_TEST(kprobes != NULL);
> -       CU_TEST(strstr(kprobes, KPROBE_2 + 2) != NULL);
> +       CU_TEST(strstr(kprobes, &KPROBE_2[2]) != NULL);
>         free(kprobes);
>
>         ret = tracefs_instance_file_append(NULL, KPROB_EVTS, KPROBE_1_RM);
>         CU_TEST(ret == strlen(KPROBE_1_RM));
>         kprobes = tracefs_instance_file_read(NULL, KPROB_EVTS, &size);
>         CU_TEST(kprobes != NULL);
> -       CU_TEST(strstr(kprobes, KPROBE_1 + 2) == NULL);
> +       CU_TEST(strstr(kprobes, &KPROBE_1[2]) == NULL);
>         free(kprobes);
>
>         ret = tracefs_instance_file_clear(NULL, KPROB_EVTS);
> --
> 2.31.1.498.g6c1eba8ee3d-goog
>


--
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
