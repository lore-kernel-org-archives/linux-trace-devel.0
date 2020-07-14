Return-Path: <SRS0=mFmS=AZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5460FC433E1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 12:07:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B3712220D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 12:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594728446;
	bh=5gZk47XXu8yR80kSOWxlW8zxVFUEtfc0FzWPBqAWDf8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=TnJwJ4hSN8Mc2bQ4GdJgqxcAhaXxKnSb2nDNoO8AWqEGHFnCKmLLMAeXWgK8m9z1J
	 KQb36aPfTMD6boucvEZqgu1Abbipysooqr5IxMD5u6uQPXRveWsHQOwfR8lIXZ3JVP
	 8ICyZFcEqgVmTnFHaYtLrMMs8PRnqr1CoOi2rfgU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgGNMH0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Jul 2020 08:07:26 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42542 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726041AbgGNMHZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Jul 2020 08:07:25 -0400
Received: by mail-wr1-f67.google.com with SMTP id o11so21187073wrv.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 05:07:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8GwwxZbyvmYxzmY5/CPV+UmKkS1ECz0kGB2RSAn/dsU=;
        b=OSLpgk00k4CtXU+PSoCqsyo2RU41x7SuEPxaAxsYy5SilFQD+TQM6BxqLk7Be+gUPJ
         3Od3a65KK5eFClU2qkdNXAPVqCq4OomlKnN02C4zM9S1gLpoPGX43d+s/p/LrXRv3hfz
         ciTzTkO1inlU+Y69wEhTHqakJ/ykqU38IQ4p/m0tKBkIZ6hWec/zWmcrghVZQhjcShOx
         vPH7/FPza9Dxx6pSm7wxBVjuK66XU4aQ54G6RpF4Eo962Ar8g6KK9isBDs/RIhmeDFS1
         nBSmuX+wvByMNju6Cm7hc2zJLHUzijQLD13S9UpfHE/ABF1ibKPVaSWQDZQulfF2+Dbu
         eWrQ==
X-Gm-Message-State: AOAM530IsgWP0cODfEOpw5WTIKNv0r7GOEuXMvvl7Iw32hR89zYrXZbh
        GwqcFa3tEHW6jqcLyeZ8FPSFpgGz/2bRPQTLC1FZqw==
X-Google-Smtp-Source: ABdhPJzpYiKC7wx6elgKBjfx6F8BJFGhVv+taXkq4OnaQ8ooY0eM25aDQNTfVWPnNFL/yvukjBVChYw83t780wVaVXg=
X-Received: by 2002:adf:fcc5:: with SMTP id f5mr5446622wrs.60.1594728443684;
 Tue, 14 Jul 2020 05:07:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200714103027.2477584-1-tz.stoyanov@gmail.com>
In-Reply-To: <20200714103027.2477584-1-tz.stoyanov@gmail.com>
From:   Namhyung Kim <namhyung@kernel.org>
Date:   Tue, 14 Jul 2020 21:07:12 +0900
Message-ID: <CAM9d7cg-5sJ-iqCU25MqmdTOdoWPqcyFJFqdc67PdRwjwqqPsA@mail.gmail.com>
Subject: Re: [PATCH 0/8] Few libtraceeevnt fixes, suggested Namhyung Kim
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hello,

On Tue, Jul 14, 2020 at 7:30 PM Tzvetomir Stoyanov (VMware)
<tz.stoyanov@gmail.com> wrote:
>
> Fixes in libtraceeevnt, suggested by Namhyung Kim <namhyung@kernel.org>
>
> Tzvetomir Stoyanov (VMware) (8):
>   trace-cmd: Document tep_load_plugins_hook()
>   trace-cmd: Handle strdup() error in parse_option_name()
>   trace-cmd: Fix typo in tep_plugin_add_option() description
>   trace-cmd: Improve error handling of tep_plugin_add_option() API
>   trace-cmd: Fixed broken indentation in parse_ip4_print_args()
>   trace-cmd: Fixed type in PRINT_FMT_STING
>   trace-cmd: Fixed description of tep_add_plugin_path() API
>   trace-cmd: Handle possible strdup() error in tep_add_plugin_path() API

Shouldn't the prefix be libtraceevent ?  Other than that,

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks
Namhyung

>
>  lib/traceevent/event-parse-local.h |  2 +-
>  lib/traceevent/event-parse.c       | 10 +++---
>  lib/traceevent/event-plugin.c      | 50 ++++++++++++++++++++++--------
>  3 files changed, 43 insertions(+), 19 deletions(-)
>
> --
> 2.26.2
>
