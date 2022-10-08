Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1CC6C433F5
	for <linux-trace-devel@archiver.kernel.org>; Sat,  8 Oct 2022 01:21:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiJHBVe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 Oct 2022 21:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiJHBVd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 Oct 2022 21:21:33 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0C6DB75E
        for <linux-trace-devel@vger.kernel.org>; Fri,  7 Oct 2022 18:21:33 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id v10-20020a17090a634a00b00205e48cf845so8638197pjs.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 07 Oct 2022 18:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/8FOvw7/C/23XTe8yuFIiK7B7eIyV0Szlwuf7ElF/K8=;
        b=IVS05BQpFhUKQbFEofp9dQJVlxKqKISwdEDNslR2Psnq1auWOH2WvAenP7Aaar8sYH
         6/tZJDc2VICha3brcIIUr6ARa9EKBDNUWfW9p8Jy3G96ceScUTLnYX8efly85yGXSlik
         NZvRX2d+l/mk8qzFPsfvkgjfpinq1DlWO79RcT6mrHR416Aqv8sKBgMIs4qyPKk3vQhO
         AUFOTg3HkL3aQAYMSpSj4lg6p8Ba5FleRlZNakmfuAoszoWjyTUmhoTozwKDtgtf7Vsq
         Qlfv0+40vrn+VbFGftiQQaRGqk3+NdtI/uxx+z9Pen3TGfvJVmTp2PwZnPysEzwA/eB2
         6BGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/8FOvw7/C/23XTe8yuFIiK7B7eIyV0Szlwuf7ElF/K8=;
        b=rKX5tZ0VrpUltjGp+LAGIOGuuuIGNE2ai072wjUp5XqhzDWoxC0uZASvqk8pMROupN
         gGwkH2ieikgZsa4awhoh8lD7fW8//zLwElvqKdC7Lu2x84GEHMGfQieDkf30KLM4avQA
         I01eVPIqdJ7pJoC0RdtzoMpTsR44tz6ndXqKwRPyb4n6CGKl/2etNT2ltYq54nAd87AI
         2biGpSupHxurLdPStSfoEUXIJzIqkaYei31HqPEnx4DTZxEettisNwLvqLDMfwBqbbIX
         eUt9u5ELgZCB6Wboyvqj+YjZyTNsdwkvtQbGVHmDtkKm9RINKL3s4kBfHtXmkQaOKVG5
         mR7g==
X-Gm-Message-State: ACrzQf2c3mYpD+9nIYn+Q27EwGoNRrNR+Ti/8/3wfj8I/Xs2XfYUIXWc
        Fx+EUpbn3FEMz/gHN36qt20=
X-Google-Smtp-Source: AMsMyM4l0Ts8sjAS/FavN/VRH6fvW/bIADiqWhCqe+DuKCT+mOGDzjz6k+HQwjDBi0fXwyqu3/JwnA==
X-Received: by 2002:a17:90b:1b0a:b0:203:3947:1a73 with SMTP id nu10-20020a17090b1b0a00b0020339471a73mr8340841pjb.43.1665192092671;
        Fri, 07 Oct 2022 18:21:32 -0700 (PDT)
Received: from localhost ([58.34.94.196])
        by smtp.gmail.com with ESMTPSA id t1-20020a170902e84100b001782398648dsm1826389plg.8.2022.10.07.18.21.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 07 Oct 2022 18:21:32 -0700 (PDT)
Date:   Sat, 8 Oct 2022 09:21:29 +0800
From:   lijiazi <jqqlijiazi@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Ingo Molnar <mingo@redhat.com>,
        "Jiazi.Li" <jiazi.li@transsion.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] ring-buffer: Add barrire in rb_move_tail
Message-ID: <20221008012128.GA6772@Jiazi.Li>
References: <20220902085641.32ba1651@gandalf.local.home>
 <20220905030209.GA5577@Jiazi.Li>
 <20220906122542.1bab4663@gandalf.local.home>
 <20220907081358.GB24124@Jiazi.Li>
 <20220915081414.GA12602@Jiazi.Li>
 <20220928105443.1e7e4555@gandalf.local.home>
 <20220928105935.578b72b6@gandalf.local.home>
 <20220928162908.07b12250@gandalf.local.home>
 <20220929091201.GA21685@Jiazi.Li>
 <20220930174934.7c5ec85f@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220930174934.7c5ec85f@gandalf.local.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Sep 30, 2022 at 05:49:34PM -0400, Steven Rostedt wrote:
> On Thu, 29 Sep 2022 17:12:01 +0800
> lijiazi <jqqlijiazi@gmail.com> wrote:
> 
> > > Actually, that failed my testing (for other reasons), can you try this one?
> > >   
> > Sure, thank you.
> 
> Have you had a chance to test this yet?
> 
> The merge window is about to open, and I have it already tested through all
> my tests. But I want to hold off pushing it to next until I have a
> tested-by from you.
> 
> Thanks!
> 
> -- Steve
Sorry for the late reply, I just finished my National Day holiday.
Up to now, the crash issue has not been reproduced with this patch.
Thanks!
