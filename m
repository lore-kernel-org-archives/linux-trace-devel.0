Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0079FC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Jan 2022 15:47:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240642AbiAQPro (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 Jan 2022 10:47:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237369AbiAQPro (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Jan 2022 10:47:44 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F9BC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Jan 2022 07:47:44 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id e19so21621184plc.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Jan 2022 07:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JDX7NleBo4ZddFDpvO+9CuA+Jc8yptYbjQiv5yP+Y44=;
        b=cWJxVUKG+lTwQ1f5OodVegadAt/EiQG3eD2TlBGkqvkHbUM2gNBR8McWVtSbDTvcQG
         OxG20IT0XqwbekPHXec0AI+YvCnIgF+bwa52GLp4O2obJf3I2H5SK3PrK5QIPNx+Be8V
         PsLgO9GnPSXNXrX73W4Yzyp7/3BGFC5oN7JgeQuXTr7ZnkqqSmxc8NsgY+0wxcYrBm4E
         bPZ2CXqfIbmXnjEnCXo+a/BWdoJxMZjShULeWJFnCy5u6s7b5r+tr67ZqRQD65emIJOU
         rraU+A1WtlK7y1tFBQhUpJkZO5bUdYfO8f4XVan+M4hwBm45NLmBl8WbquGQfNum0F86
         gHVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JDX7NleBo4ZddFDpvO+9CuA+Jc8yptYbjQiv5yP+Y44=;
        b=qekbm24epFctJut0XfyJBNnecdezWoHs/OEv0EP3xqT82tBVVLRArbDCuC223O/aZG
         nXgBTfMTB+pV+ff9CrC35isSj3XSQsQNbuLnUJKqUAbevy8n7FNxHFKatMeVKhlXMyJE
         wdSs12X7QIl0yKT/Uab/ZEZ2S+PDtbi4eZYScmlNW87OkxVoaTFBdnkPJ1OSq3O949ag
         sUL7i3RmIPaAgt1isNxYS2PrmbqgeXVXVxh3m2GvCCV3XefEYodKx+giu8+fcEn9Eh3m
         fHur3sS0LAfcnlpv9dtyK0t8jsBFf4FYfF3PgBk6KyMc1fVsoLTXek++/IYdfAHzl76Q
         599g==
X-Gm-Message-State: AOAM532XcvI0as+qDmVJ9D0Nry+8vupVEBbgevtIakxMkXF7oAGTax2p
        H/oHrpv3D9CIwzn1i5oiwtxhhGOCX5C+sRGUjyHfMYJvtwA=
X-Google-Smtp-Source: ABdhPJwSZtCHOnhxNlyt6+8hryhjVH4WZEseXZljZIreKQeHeySGxRcLgq/FHtkrfuFzxN3xObr4/UBLBpMi3YFav1U=
X-Received: by 2002:a17:90a:8c0e:: with SMTP id a14mr34847563pjo.111.1642434463623;
 Mon, 17 Jan 2022 07:47:43 -0800 (PST)
MIME-Version: 1.0
References: <20211210105448.97850-1-tz.stoyanov@gmail.com> <20211210105448.97850-17-tz.stoyanov@gmail.com>
 <20220115105959.591892e1@gandalf.local.home>
In-Reply-To: <20220115105959.591892e1@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 17 Jan 2022 17:47:27 +0200
Message-ID: <CAPpZLN7EFy=S9UaidojoCnfXPVgU-=SbXSGUjA88maT_wfWEUA@mail.gmail.com>
Subject: Re: [PATCH v7 16/25] trace-cmd library: Read headers from trace file
 version 7
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, Jan 15, 2022 at 6:00 PM Steven Rostedt <rostedt@goodmis.org> wrote:
[...]
> > +
> > +static int read_headers_v7(struct tracecmd_input *handle)
>
> I really like how these changes are coming. This makes the reading of the
> tracing file much more manageable. Great job Tzvetomir!
>
> Only comment to this patch is, as I've said in other patches, I don't think
> we need to call this _v7, just "read_headers()" would suffice.

The read header logic is very different, we should name the old
function somehow. Now we have
           read_headers_v6() / read_headers_v7()
I can rename them to
           read_headers_old() / read_headers()
or
           read_headers_nosections() / read_headers_sections()

>
> -- Steve
[...]

-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
