Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7634C433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 04:20:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97748613D6
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 04:20:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbhEGEVd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 May 2021 00:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbhEGEVd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 May 2021 00:21:33 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D56C061574
        for <linux-trace-devel@vger.kernel.org>; Thu,  6 May 2021 21:20:32 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id m37so6256279pgb.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 06 May 2021 21:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ia7+TPdLUKdh1AbDehjbUQQJtxJloQ+oNYJSGTiX+nI=;
        b=tmE04VUSmRBpox9ndJjY2Nrkzh0hkY72L8GGq1FpmHVYtkRo+UUl3ENgasjRoN1cTg
         DlivPpHxO/X0MAxH4SagPX1T6b734GDCVyqZ/EooPv77GyCc7Y2SUsuWYEhXpaTHKlE0
         TU2RPsv37gc0SgG1U3g9/asjGeD94ly3rZjWxD49L5sEgIQ4+zCecDIjRET6PcaYsguG
         zHT2B2dc/7r86vtAK8hGAqyxxO9kc4c1+Trw8mU99kR2/klFx1kzcigeml1jxL/mrlig
         zLEB4O0m3T2m58YvFZpsXQxPD32e5k6jtycc1X3esadwURGrIdvqmeNoWOqcOhCeiXeY
         ThWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ia7+TPdLUKdh1AbDehjbUQQJtxJloQ+oNYJSGTiX+nI=;
        b=c7QaHSEvDE6s6MtUeBGOFFagBirkc+4TauPqEtOwptawHEmS/NjqcTfTpK8tD/kzBR
         VhhoJup5ZFoweZ1dRHZvc3f0W1++fdO+iG5+tSmcSHCJh7BgbCveUcn3UnZzavUwqfU+
         +65N2HKGNMAfX43QjyQCbdf0mGR9/jf4BNeFYRjhD08BjWKYZfC5GY70BMi0yvLsYfFL
         fIyR+nPJ1B2ql5i4ete0YOTYgXMoqcrQhGVmEyE16vO60PC9IrXSNXHE4VkHkYpI0FJc
         s33+aYZPHqK12H2Ifw0Y2LfBf6eAq7Ow2n5mmQAaDGWfV1yu7ppsDifBHnquTeVWeh7i
         avUg==
X-Gm-Message-State: AOAM532ir9Gmsg/QPzhJcL/BxHUkDOkTvthB0EgloeJPbVp2T3lV0smt
        B5n2+fjSUb4Zcr8vKffipj6NI5YxZ03rh+NqWjvf9oZ4y09/uw==
X-Google-Smtp-Source: ABdhPJwBUQ0RNVwU2Wc2nHxGLvIuZLYBskMMw33CX1P/v6lc4BajqOJWooFjU7nqlnQrQ7o0zcQubcmy13bKGW1iI9s=
X-Received: by 2002:a62:3892:0:b029:250:4fac:7e30 with SMTP id
 f140-20020a6238920000b02902504fac7e30mr8279088pfa.81.1620361231761; Thu, 06
 May 2021 21:20:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210506171400.7c00b731@gandalf.local.home> <f4c372f2138151299588b702567827a61954f775.camel@suse.com>
 <20210506214012.741cbbd7@oasis.local.home>
In-Reply-To: <20210506214012.741cbbd7@oasis.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 7 May 2021 07:20:15 +0300
Message-ID: <CAPpZLN48irG2cuPZi4+RAORbkxpnHudNf1wdXBdjYDmr4e8bhw@mail.gmail.com>
Subject: Re: [PATCH v2] trace-cmd: Find PID of host-guest task from tracing
 vsock connection
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Dario Faggioli <dfaggioli@suse.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, May 7, 2021 at 5:12 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 07 May 2021 02:32:05 +0200
> Dario Faggioli <dfaggioli@suse.com> wrote:
>
> > What am I missing?
>
> When you have 10 guests running, and you are only tracing one. How do
> you know which guest that kvm exit was for?
>

As Dario said, we can get the guest from the /proc/{kvm_exit task
ID}/status - the Tgid written there is the guest, the host task which
runs that guest.

> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
