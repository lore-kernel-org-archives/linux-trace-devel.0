Return-Path: <SRS0=hDql=YE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B9D0ECE596
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Oct 2019 18:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7A9121A4A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Oct 2019 18:18:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JfBWvsYf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbfJKSSk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Oct 2019 14:18:40 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45071 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728740AbfJKSSj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Oct 2019 14:18:39 -0400
Received: by mail-lj1-f193.google.com with SMTP id q64so10693467ljb.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Oct 2019 11:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=emZaz78Pq3lz0pzqygXZ/5r3fwySwfSDHOOApfMTZPo=;
        b=JfBWvsYfPFjffB5uyc3keAvbN4QRyUqQcEYUVfuZn+mzIU7h81EbX6XDAJUgPzmdve
         9+zKUch/6F4wPwDBOtk5mdvtAcfOanvlFNpzkG7DanF/jdBfiDWlQPoev1SkllZoqkZ6
         sDCPME+lGXJWQ/cDOo6Wci/GIe78cI1+SWjSMi3HLiz8TTYcpFtb77U89MQjMQGkZqYm
         XSQSrOHDCIeoM893vywusyY93uBF8EyxE3ICNerDHudfcbeq+4pbnZ7hJLOZaJLmF91A
         8hcB4dgc5jkR1jUJcIsCx3+Ee3ZpzUlUXANQ4TOwCAsM/XRVnblpTpSZvuG5g5vh0TNj
         gYtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=emZaz78Pq3lz0pzqygXZ/5r3fwySwfSDHOOApfMTZPo=;
        b=aAd6SPAyo4RcCq2YebeFboRLYbvvaIAW49MurYCB8E2RL5aPFCXOANV9xPqGCi/myz
         J85dw4LFl8Hl0Tzv8XgczuFktEY26rVTwz+2pKKuwVpL0zeAHlrvsUi+I6u81r3mKN/5
         2pvrGmKtFX7vIiAvcjlCssbGiTuhP94bWwrM5tpGN+Ohen+fTOHLR3xKaBBL8T+t8974
         wuCcRqarT/lrIF3XS0Mliap6DIY6JkvHXJ92D0quQjYHO38Hh6siP7avw46oMGVqN3jV
         +zg+Tjrihgu4ylEKDwWC5wixPuuWN6xDXB0/Vk865k+vwOaheLjck+3plTOMyNt609uc
         MlEA==
X-Gm-Message-State: APjAAAWLUj1H7FPJoDJyCBao5VriZsu+oTE1V1WIZHRF0hhxtH3d4bKf
        3R3VpSxzeAejZH0yDv7opVNgrDumW4Q=
X-Google-Smtp-Source: APXvYqxBodLv5Fui6b95s3ktxeRzSxL/mAy3aT55kOkSNE3vEjbezsV5z+WjzqAjdfigasB5bVAXjA==
X-Received: by 2002:a2e:b163:: with SMTP id a3mr9549141ljm.187.1570817917126;
        Fri, 11 Oct 2019 11:18:37 -0700 (PDT)
Received: from razdolb (128-72-185-159.broadband.corbina.ru. [128.72.185.159])
        by smtp.gmail.com with ESMTPSA id n12sm2247527lfh.86.2019.10.11.11.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 11:18:36 -0700 (PDT)
References: <20191010212429.469155-1-mike.rudenko@gmail.com> <20191010180205.06aab874@gandalf.local.home> <9a5c1135-12b9-27c2-159a-7468b0877650@gmail.com>
User-agent: mu4e 1.3.5; emacs 26.2
From:   Mikhail Rudenko <mike.rudenko@gmail.com>
To:     "Yordan Karadzhov \(VMware\)" <y.karadz@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 0/4] Fix KernelShark appearance on dark color schemes
In-reply-to: <9a5c1135-12b9-27c2-159a-7468b0877650@gmail.com>
Date:   Fri, 11 Oct 2019 21:18:34 +0300
Message-ID: <87r23jdu2t.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 2019-10-11 at 17:11 MSK, Yordan Karadzhov (VMware):

> Hi Mikhail,
>
> Thanks a lot!
> I am pushing the patches.
> Is is possible to send us a screenshot? I am curious to see how
> KernelShark looks on your dark color scheme.

You're welcome!

Here are the screenshots with and without the patches applied:
https://imgur.com/a/MyXdiEN

Best regards,
Mikhail
