Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51700C83013
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Dec 2020 12:58:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1616321D91
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Dec 2020 12:58:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgLCM5x (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 3 Dec 2020 07:57:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730563AbgLCM5x (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 3 Dec 2020 07:57:53 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC71C061A4E
        for <linux-trace-devel@vger.kernel.org>; Thu,  3 Dec 2020 04:57:13 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id q22so1208446pfk.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 03 Dec 2020 04:57:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AtIPhi7wFV2yRlp7DGK1YjSwUGpByv7S2Vbhq6OHja4=;
        b=rf92y6MB1AAvsGEm02UkkExBbYM6FmkRJV4OwO5GWe4xatVLhphNocYSUhdQUm3STV
         r2lwScn818as+moFmh4UlxMAhnpXpHK56BrtiRtQQu1/bE/rLLXzt38du+USO0kpcLgI
         6fyVUTe4Qzj7PHnB6JQLprUuWBn+aAynKuE5GEb0I0MxKHNr6Z0nnv9Jy+eLZvfJ7F4k
         Eo5ZXKn1Jy3Ny1kD8L6RCxPFRMe/8yjSOjOARvuCKRc2uvF21mfeKk/0qWmJ7cf5R4V5
         ZaUX7UQ2g/3HnvQTBj9NHuH8NCyDPGW98Tvn4gZWNDyfzZQ6MPAtMPd2zLcKSlCICNYb
         Yg6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AtIPhi7wFV2yRlp7DGK1YjSwUGpByv7S2Vbhq6OHja4=;
        b=YpXLL3V0+edi24NXtZs8ADGiN+/PBJqWkwy4rpO4zDZhuXYWzYxFTjCZpnPeP5DufC
         6b+BTKRgJzr/SBcXktms7sgj4U1TOsA+sWXes8WZrgTVydgumRjmYYY1nJhHRblS2e8j
         qn4X0KR+gwCrGfzAjJUy9smABu3nMOQ2C738tzRdbARiIJN8h3qqqMG9BNrG4LdwzYb5
         p7vvMLUzYugOT4zlyIG1lRyeWZrIp+T/yfmo7Cu+qsZ+7lb5+zfym5zm1+gmVIs59AVf
         mnN2pP6MFcCTsZ27OegfIpby4g9kw93yM0c1V2Ie/EvpX0zZEPYMkJ8Ka0puh7POpuPj
         LhdQ==
X-Gm-Message-State: AOAM5304+Gh3+2JjRTU0D3wF/VSRv5/Vo5mzLGbMBZ5M5tAL48Zf8K4h
        /TgFGWe5APXdMcVUnsWhjHWWa23+hTdG5XM96OBvXXqbGY7XW92d
X-Google-Smtp-Source: ABdhPJxYQ0VlxG2UafBDr3TcqSp9ZBzSf8tDqSHeXDl/OSVgvsuA3UE4GgozeTwbC1njBrA1ROiEM9DNw7HuqT2DZI4=
X-Received: by 2002:aa7:8a0d:0:b029:19c:2209:7b59 with SMTP id
 m13-20020aa78a0d0000b029019c22097b59mr2847540pfa.81.1607000232716; Thu, 03
 Dec 2020 04:57:12 -0800 (PST)
MIME-Version: 1.0
References: <20201029111816.247241-1-tz.stoyanov@gmail.com>
 <20201029111816.247241-10-tz.stoyanov@gmail.com> <20201202204735.61d112c8@oasis.local.home>
In-Reply-To: <20201202204735.61d112c8@oasis.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 3 Dec 2020 14:56:56 +0200
Message-ID: <CAPpZLN6eeDSZPWwwov1+UgPsgjrQ4hMnJ2Dm7TUe=pgSnrhTjA@mail.gmail.com>
Subject: Re: [PATCH v25 09/16] trace-cmd: Add scaling ratio for timestamp correction
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Dec 3, 2020 at 3:47 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 29 Oct 2020 13:18:09 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
> > @@ -2181,7 +2184,9 @@ static void tsync_offset_load(struct tracecmd_input *handle, char *buf)
> >               host->ts_samples[i].time = tep_read_number(handle->pevent,
> >                                                          buf8 + i, 8);
> >               host->ts_samples[i].offset = tep_read_number(handle->pevent,
> > -                                             buf8 + host->ts_samples_count+i, 8);
> > +                                             buf8 + host->ts_samples_count + i, 8);
> > +             host->ts_samples[i].scaling = tep_read_number(handle->pevent,
> > +                                             buf8 + (2 * host->ts_samples_count) + i, 8);
> >       }
>
>
> I was thinking the above code may read better if we changed it to:
>
>         long long *time_buf;
>         long long *offset_buf;
>         long long *scaling_buf;
>
>         time_buf = (long long *)buf;
>         offset_buf = time_buf + host->ts_samples_count;
>         scaling_buf = offset_buf + host->ts_samples_count;
>
>         for (i = 0; i < host->ts_samples_count; i++) {
>                 host->ts_samples[i].time = tep_read_number(handle->pevent,
>                                                            time_buf + i, 8);
>                 host->ts_samples[i].offset = tep_read_number(handle->   pevent,
>                                                            offset_buf + i, 8);
>                 host->ts_samples[i].scaling = tep_read_number(handle->pevent,
>                                                            scaling_buf + i, 8);
>         }
>
This code is rewritten in "trace-cmd: Add timestamp synchronization
per vCPU" patch
in a better and safer way.

> -- Steve
>
>
>
> >       qsort(host->ts_samples, host->ts_samples_count,
> >             sizeof(struct ts_offset_sample), tsync_offset_cmp);
> > @@ -2534,6 +2539,7 @@ static int handle_options(struct tracecmd_input *handle)
> >                        * long long array of size [count] of times,
> >                        *      when the offsets were calculated.
> >                        * long long array of size [count] of timestamp offsets.
> > +                      * long long array of size [count] of timestamp scaling ratios.*
> >                        */
> >                       if (size < 12 || handle->flags & TRACECMD_FL_IGNORE_DATE)
> >                               break;



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
