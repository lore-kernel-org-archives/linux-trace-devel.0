Return-Path: <SRS0=onCu=SZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56602C10F14
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Apr 2019 06:29:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2043920674
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Apr 2019 06:29:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qPbCKmm1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbfDWG3y (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Apr 2019 02:29:54 -0400
Received: from mail-ua1-f66.google.com ([209.85.222.66]:36950 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfDWG3y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Apr 2019 02:29:54 -0400
Received: by mail-ua1-f66.google.com with SMTP id l17so4392487uar.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Apr 2019 23:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WIIRty9oQ+AWa4rrJCtCduHTKSHiCYLL16SbPrTrhu0=;
        b=qPbCKmm1DfzJ/lgntIG01A4rwMhErb0fnvoTbghP5Elq5ereE42bSe8bZiyjfRkoFC
         uI6H/d8xc6TBioQZc7hx9nY1mjoQtLEVLSiCvZejOteMVRqm0AF6ZMWUY25M+E9Sn0Oi
         d89Ssdj58NSZp6p8FynajmTsFuucqiajW4pxRd6Vnxn8okLVWCHs1tULGSmS60lrqCow
         3bQdcSi9WoGEhF9/ufKikFTejObYsm1U6fdovKAj1fdKxPNIEAAi9g3RsPQfq3JBLfWZ
         TJFW0ZZqAFmF8OPnQyCCLe0TzjaRN23xpc14CoMU3RQD8SHk86pUboDeUgezXhzZjoCE
         gBew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WIIRty9oQ+AWa4rrJCtCduHTKSHiCYLL16SbPrTrhu0=;
        b=StLTHUKU033QRll3Snuc8RGGlzPjvu8+oUxFKYJ/ZM+ntTAs5ki3zqkxXVo0btIALb
         YEx7xLZ2JY/9R5A9bG/PcTyC7uRzpzSYeuxdMkVr+s1WhC0OV1eGtbeYeXPpg66M5phW
         +X3b6X60a/ER/L0sFWyI6+uR6Fr4f6uDYhpX6xpnDxuDFqdWm6fQtfAaNuT3YDglFUpV
         rMZu488GHrPD0hDbPISBXnGGg6Uj2f1EgnCC//TaV9pwgQuRfh+NmEJctpHhz1AzHo2z
         vHr8oAaEv5NuJqCd6CHOfBxLlgLQ6fvcEc3xaBiHxhUzBNbzxN0XkKr2SIrpd8M10oW1
         hX5Q==
X-Gm-Message-State: APjAAAXRAeEUCqm5hZhNpGezK1HdYcGvFOeiHWFkdPouDS/TKVbs/Qwm
        nCevLbhhY+jNNdbWSQavFeZ3f1ECljomxBNbFmbekw==
X-Google-Smtp-Source: APXvYqzuffo3MPKCzmioVr2Sg6fJmIGnXugf7z8+QZxMtDE7dwUmSmohLlitIb76qIyyzxjIMpsds1qZxu2eTHMb1BM=
X-Received: by 2002:ab0:2399:: with SMTP id b25mr11743955uan.129.1556000993700;
 Mon, 22 Apr 2019 23:29:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190416183257.247902-1-rrangel@chromium.org>
In-Reply-To: <20190416183257.247902-1-rrangel@chromium.org>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Tue, 23 Apr 2019 08:29:15 +0200
Message-ID: <CAPDyKFqYNMhDKy94zV8Bk80OUiS9JNFf2EmkbhJ0W_N=5=bZJQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Add trace events for SD registers.
To:     Raul E Rangel <rrangel@chromium.org>
Cc:     "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>, zwisler@chromium.org,
        Steven Rostedt <rostedt@goodmis.org>,
        hongjiefang <hongjiefang@asrmicro.com>,
        Jennifer Dahm <jennifer.dahm@ni.com>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Kyle Roeschley <kyle.roeschley@ni.com>,
        Avri Altman <avri.altman@wdc.com>,
        Simon Horman <horms+renesas@verge.net.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 16 Apr 2019 at 20:33, Raul E Rangel <rrangel@chromium.org> wrote:
>
> I am not able to make a single event class for all these registers. They
> all have different struct sizes and different printf formats.
>
> Thanks for the reviews!
>
> Changes in v2:
> - Made trace_sd_scr print out flags.
> - Add BUILD_BUG_ON to make sure tracing stays in sync with structs.
> - memcpy using sizeof(__entry->raw)
>
> Raul E Rangel (4):
>   mmc: core: Add trace event for SD SCR response
>   mmc: core: Add trace event for SD SSR response
>   mmc: core: Add trace event for SD OCR response
>   mmc: core: Add trace event for CSD response
>
>  drivers/mmc/core/mmc.c     |   4 +
>  drivers/mmc/core/sd.c      |  10 ++
>  drivers/mmc/core/sd_ops.c  |   6 ++
>  include/trace/events/mmc.h | 204 +++++++++++++++++++++++++++++++++++++
>  4 files changed, 224 insertions(+)
>
> --
> 2.21.0.392.gf8f6787159e-goog
>

Why do you need this? We already have these card registers reflected
though sysfs files, isn't that sufficient?

Kind regards
Uffe
