Return-Path: <SRS0=a8si=S2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.6 required=3.0 tests=FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3774EC10F11
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Apr 2019 15:31:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0ED6921773
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Apr 2019 15:31:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730932AbfDXPbW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Apr 2019 11:31:22 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:40590 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730560AbfDXPbW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Apr 2019 11:31:22 -0400
Received: by mail-it1-f196.google.com with SMTP id k64so6877705itb.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Apr 2019 08:31:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4jYIXqAv156sqB9xpzJsjeRlS9lW8nAohtQ+TmRz3ws=;
        b=WCpLBhTsn0PlDCqSZ0KDCH7AxewJxuqKVaAGi+0OoHjj4UbCAIQmLTimOzb8YJWnc5
         Wd9rabvBQ+79PAI51dr5W5biK9rJsmdsfjNJ0tv102s46MzW6Mays5bQmmiibelVF8SG
         V8N1eHw8RRrgTh7+SFPg+tbBtcJm3NjIUh3D8zUdsNfOHPUqF+2rK6OUtAb865pMeLZi
         1f5okbFSkq3z20H2FQSfYepmw/nVn+DIiq+YRLPoF9EOKn/7MS2vSXI4jgp9Ir6lacil
         S1TG/+C45vRbeoWnai+6GwkG93vPQSe+nu5wKYZaq2rfdFPr/XqHbv7D7WX81guNMfgQ
         u9YQ==
X-Gm-Message-State: APjAAAXzZeAqfA/jsxoBfULBH3DLE+tBJ5dsmLVHD6KGAbO/E1OplYdy
        U2zecgwLdAb5DwyKb89QN4P8yA==
X-Google-Smtp-Source: APXvYqzz64F0lOg7iIhoJFNqhddAT7aUo1jcMpxrDizoLiVtGSW6wqww3LhI5am9R6gtRnrLg0A8rQ==
X-Received: by 2002:a02:9108:: with SMTP id a8mr5594877jag.107.1556119881054;
        Wed, 24 Apr 2019 08:31:21 -0700 (PDT)
Received: from google.com ([2620:15c:183:0:20b8:dee7:5447:d05])
        by smtp.gmail.com with ESMTPSA id s124sm9560049itb.42.2019.04.24.08.31.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 24 Apr 2019 08:31:20 -0700 (PDT)
Date:   Wed, 24 Apr 2019 09:31:15 -0600
From:   Raul Rangel <rrangel@chromium.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>
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
        Simon Horman <horms+renesas@verge.net.au>,
        Raul Rangel <rrangel@chromium.org>
Subject: Re: [PATCH v2 0/4] Add trace events for SD registers.
Message-ID: <20190424153115.GA186956@google.com>
References: <20190416183257.247902-1-rrangel@chromium.org>
 <CAPDyKFqYNMhDKy94zV8Bk80OUiS9JNFf2EmkbhJ0W_N=5=bZJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDyKFqYNMhDKy94zV8Bk80OUiS9JNFf2EmkbhJ0W_N=5=bZJQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Apr 23, 2019 at 08:29:15AM +0200, Ulf Hansson wrote:
> On Tue, 16 Apr 2019 at 20:33, Raul E Rangel <rrangel@chromium.org> wrote:
> >
> > I am not able to make a single event class for all these registers. They
> > all have different struct sizes and different printf formats.
> >
> > Thanks for the reviews!
> >
> > Changes in v2:
> > - Made trace_sd_scr print out flags.
> > - Add BUILD_BUG_ON to make sure tracing stays in sync with structs.
> > - memcpy using sizeof(__entry->raw)
> >
> > Raul E Rangel (4):
> >   mmc: core: Add trace event for SD SCR response
> >   mmc: core: Add trace event for SD SSR response
> >   mmc: core: Add trace event for SD OCR response
> >   mmc: core: Add trace event for CSD response
> >
> >  drivers/mmc/core/mmc.c     |   4 +
> >  drivers/mmc/core/sd.c      |  10 ++
> >  drivers/mmc/core/sd_ops.c  |   6 ++
> >  include/trace/events/mmc.h | 204 +++++++++++++++++++++++++++++++++++++
> >  4 files changed, 224 insertions(+)
> >
> > --
> > 2.21.0.392.gf8f6787159e-goog
> >
> 
> Why do you need this? We already have these card registers reflected
> though sysfs files, isn't that sufficient?
> 
I was not actually aware that the registers were exposed via sysfs. I
was debugging a problem where the host controller was returning all
zeros when reading from the card. I wasn't aware that it was returning
all zeros until I added tracing. It made it quite easy to diagnose the
problem by just diffing the two traces.

Also if the card fails to mount because the data is invalid, the
registers would not be exposed via sysfs. So tracing makes gives us an
easy way to debug these types of failures.

Thanks,
Raul
> Kind regards
> Uffe
