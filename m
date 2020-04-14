Return-Path: <SRS0=o21U=56=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07ABFC2BA19
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Apr 2020 14:15:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1BEC206D5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Apr 2020 14:15:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K1Rk5R4b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733263AbgDNOPQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Apr 2020 10:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733212AbgDNOPN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Apr 2020 10:15:13 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D782EC061A0C
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Apr 2020 07:15:12 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id t40so5255472pjb.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Apr 2020 07:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i8YdmIE44erG9Sciby8t9hwi5d+EHiYnEIBCq2uxbLk=;
        b=K1Rk5R4bT7qrf9if+QVva2tQFzf/PmPctLDuj3LfPuYSEBoz7c3+N/wfp+zOAej6wb
         E45tMRg2Q1Lj0OIPGEO7Ig5HeMbvy1Yf3XrZnW/Wh6bvTMKOTIK+mOkOOw/Dd8uKEMrA
         eNt88Tzx2w9kVqyVmq8qDrcRuwfe28d4VsYXT5zXvWdSLKWStpnTqSluawEeRGkXxCrw
         VPnO+xzzbsQVkPeEi/WirgM0TPcuX1hAL92GHToay3lQJ8nnxHYDdzPFXbxAlWKLqX62
         0EXmgsTge6E17229m/486141zEdQ9Y3QMA8U3bKYPEnPkpPp2inDPyUyniFkb/t+MUPU
         KmIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i8YdmIE44erG9Sciby8t9hwi5d+EHiYnEIBCq2uxbLk=;
        b=M8KBp5icjgdXMqsweRdIUCOQECXkxo83SAjIZXjNwCstu+CzaDUFzHyHRA7XAKx6OZ
         OfT2OPsIYswLlD+JyZ7Jtavi5qNZI+ktOLM4wXBJgfDbHTOgNmGb2lYNsf3sQSXierhU
         rdwPoWnguAC4gEdekXbvwkbJaqJpZqQ+rh+LsNU9E6JXJbNR+0Yg2NEiU8kU6VOdHc4X
         3foDbuaYoeaXFoLOmoFXml0h7EyJNR0oSMi5wgCSefMmGlL7JgLGy0yAOvEofLnyLh7e
         sSIRR3pFVnqoL7Dqm4ctmal//PN3hee622qt5FyxDGiOz7KA5axFEB1lHtfy5TVEw0a/
         qHtQ==
X-Gm-Message-State: AGi0PubcBCJy7ayv6aMQnYa6y0w5GYBicDDGR649ZfzwmJDd0L+0kFah
        Wzd99dtHECb5P7u1uFkr0fb53/NAggf9hny1jgN/L/e7iAE=
X-Google-Smtp-Source: APiQypLfFUeEaz57EXHgw8BARzreS0X7sap+NLw2qBjHg+d+vCYeWg/qD+A0FKQW8w1Iqt3uZjZ6CoXc3ifnFJ2g3Lg=
X-Received: by 2002:a17:90b:380d:: with SMTP id mq13mr299839pjb.145.1586873712214;
 Tue, 14 Apr 2020 07:15:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200413205346.028742220@goodmis.org>
In-Reply-To: <20200413205346.028742220@goodmis.org>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 14 Apr 2020 17:15:00 +0300
Message-ID: <CAPpZLN79C16cREUZnyxdrufLrZTVH7C4Hmn1EF-FEWuC24=HUQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] trace-cmd: Minor updates to tracecmd_unpair_peer() function
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Apr 13, 2020 at 11:53 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Some minor clean ups of Tzvetomir's code for tracecmd_unpair_peer().
>
> Instead of asking Tzvetomir to send another version, as these were
> minor changes, I just decided to do it myself ;-)
>
>
> Steven Rostedt (VMware) (2):
>       trace-cmd: Fix cut and paste header comment of tracecmd_unpair_peer()
>       trace-cmd: Make tracecmd_unpair_peer() return void
>

Thanks, Steven!
Reviewed-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
> ----
>  include/trace-cmd/trace-cmd.h |  2 +-
>  lib/trace-cmd/trace-input.c   | 11 ++++-------
>  2 files changed, 5 insertions(+), 8 deletions(-)



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
