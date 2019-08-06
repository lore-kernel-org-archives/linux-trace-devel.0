Return-Path: <SRS0=jb6J=WC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0EFAC31E40
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Aug 2019 05:14:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F7EC2147A
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Aug 2019 05:14:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hsnmy0Mo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbfHFFOX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Aug 2019 01:14:23 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39076 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfHFFOX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Aug 2019 01:14:23 -0400
Received: by mail-pf1-f194.google.com with SMTP id f17so36836199pfn.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 05 Aug 2019 22:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jKZavVM4REg3gS0Bc/9VyCOL1AdIiu6rv6MOrjYMC5I=;
        b=Hsnmy0Mo/PoQNxEjI4EoAP3hFR3anELQWa+ON/LTZFvBX8chskiMTGNQEPmyX9BUAB
         d8TWMUegbmB74h+m30hGCLnbMS5Qozw7ATlF8aghsJJNn2oCHILCHRXNldUtzkF/xr4i
         5EVMairTeLiZrRadUhf/y+q9XJyGytz6XPp3tMhrNffQ+u3OY6wsYzoN3CM1SdJ+6mwj
         8mCRGWCxvMwAFiZI3UOWJCuElJ9QwC+0os+QWwjeug60+9RBKP4PPaomp8RAOhunuWDH
         R3qS+OMhNq51vWPqowtWUsdKJs1ULDrIs7y5Zq5tm/esFr13qfzT0rhURpKEr8pM6On7
         FmkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jKZavVM4REg3gS0Bc/9VyCOL1AdIiu6rv6MOrjYMC5I=;
        b=P5OcUknR3aPSw0TPr3jTpXos76C2rjQ/BDh2R+q8JPAeV6NlZQLzMQPPtgpAqYGaog
         rRTPaca+Z0eXhePUoOnrVxowIzSDR5rOid3gGVYOF9sYjFwaha/s2FxITV3PIF9Mye5c
         RG3gUM3N6p9OC56jI5NAnZ6p6/v+eVqZQ5LDSEbi6TXKWpqeq6P3aZnmDxjrNyvoVT8q
         WeGC+Pr9j2XeYL6Jgeig8f9caMwXrR59lxmEI2ztxVh4y6hv64I4PSAJ0VrE/HpSF3S2
         saeK558hvjEM8zkYZyRltB/9Vyq+5pSO+B6bp8NgTZGhm7Xaa71dA3fs/Sn/I2cNf7sv
         RRfg==
X-Gm-Message-State: APjAAAWMK2VINk0tuKJYV9jnn42Mwy2KBns/QN3Z9A18uNGAs1oIMD8b
        BNUCo4d2NVbQsDEm56ut+BA=
X-Google-Smtp-Source: APXvYqx5lFHEKrxYiKAW+xuVW45OKvpMySzkZyGQF1OPQyybynxf6/gUASnxsNmaHWomyfOE3SW2BQ==
X-Received: by 2002:aa7:8817:: with SMTP id c23mr1792814pfo.146.1565068462300;
        Mon, 05 Aug 2019 22:14:22 -0700 (PDT)
Received: from localhost ([175.223.3.169])
        by smtp.gmail.com with ESMTPSA id h11sm89022497pfn.120.2019.08.05.22.14.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 22:14:21 -0700 (PDT)
Date:   Tue, 6 Aug 2019 14:14:18 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        linux-trace-devel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [PATCH 1/2] parse-events: deref pointer for proper sizeof()
Message-ID: <20190806051418.GB851@jagdpanzerIV>
References: <20190805102646.31142-1-sergey.senozhatsky@gmail.com>
 <20190805232103.04c6ad28@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805232103.04c6ad28@oasis.local.home>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On (08/05/19 23:21), Steven Rostedt wrote:
> On Mon,  5 Aug 2019 19:26:45 +0900
> Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com> wrote:
> 
> > Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> > ---
> 
> Hi Sergey,
> 
> Thanks for sending these!

Hi Steven,

I just realised that the patches are against v1.1.1, not the master
branch. Let me know if it's not OK.


I've some issues building v1.1.1.

	swig -Wall -python -noproxy ctracecmd.i
	parse-events.h:676: Error: Syntax error in input(3).

Which is, probably, this 'bool' variable of type filter_arg_boolean

struct filter_arg {
        enum filter_arg_type    type;
        union {
                struct filter_arg_boolean       bool;        <<<< 676
                struct filter_arg_field         field;
                struct filter_arg_value         value;
                struct filter_arg_op            op;
                struct filter_arg_exp           exp;
                struct filter_arg_num           num;
                struct filter_arg_str           str;
        };
};

Is this a known problem?

	-ss
