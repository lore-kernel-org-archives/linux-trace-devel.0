Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF4E6C433B4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Apr 2021 15:34:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DE4060BBB
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Apr 2021 15:34:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237475AbhD0PfE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 27 Apr 2021 11:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235216AbhD0PfE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Apr 2021 11:35:04 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86ABFC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 27 Apr 2021 08:34:19 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id i12so28819823qke.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 27 Apr 2021 08:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ggALVKv4Q5qMQOzuH8ZMGq4j6U4WDTPM86UYyADnm4A=;
        b=Eq2pj8lYr3ihINoS58ZY1HbYph8D4psXEwKnSda9hglUjvV3x+JCtB1VUKSyU2PNXT
         D5EFQSWW1zXXIK8vug8T8XaN5AbUGd4ssAjh3iE50CSgOk+f8nnIq/xBHCwbZzySSp/p
         d/I8gkA+iWdduC1jhzq2DGYSvhPMR3IGBkTWiUeJl4fpuS6myF4deHXYVswCDFXZVlBN
         OcSj7sPPma5bOs1TcOboix5FvElXPFOBJul3Ci4H73HzP2icLbLaqIkR0TYYLzUKGZsW
         C55G8J1Cekj6/qi0uEl/FCHJeFhO+lNbpPI0O3Hi9HDx8yAQDGJwNW6hac/hfYuBqUya
         Q1CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ggALVKv4Q5qMQOzuH8ZMGq4j6U4WDTPM86UYyADnm4A=;
        b=GLLTb0+HMiMZRDgWp+u3mFG01UXsi0YUAqZsZTUOl/NpRRRNTDeI4yzokYzG6lRkRL
         WoEGqEHwIa0qYDThw42K1Wozpqb8wkIOMWi+uXN4csdV3cfKHl/B5HPIiT3FOIKTz6DX
         P2q4yVclklj7aHURpQL3xB0ZB/IUsb4hhFSwetfqNVFPX8gr7DqR6CUIjKwYdb85eKHq
         /ehUG9hTRI8axnB/EMkY5Ej89Kl04G2MZEqYgDAC2IQczEZU/Ws9JvGkTTFRoDvTJKan
         LlCPKPSSJ9fKwcIJFvSpUT2FFxD6N32pLvNDtYBYtGKUhoKtxMG9tO2EwBxOIEAj7zHk
         JgaQ==
X-Gm-Message-State: AOAM531AWdqH+qntzyUmQu0oZgff8p5i78AAGtzWkGI2jzBpTQVIr27n
        YReKg6E3wOVDxt9QTulIRMo/5luwAF/tKB8LBvwSwOp/AJU=
X-Google-Smtp-Source: ABdhPJxR0x+ag97u63KQ9aNNzKFPC66F9L4Qkv3N+QOWrCG4Ugn0j2YAWuKyHqM3PU2eIfXaytBT4+lyi9HFrjCPEn4=
X-Received: by 2002:ae9:e886:: with SMTP id a128mr23707783qkg.20.1619537658515;
 Tue, 27 Apr 2021 08:34:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210426103528.634418-1-tz.stoyanov@gmail.com>
 <CAJWu+opRp9tN7iHGh84kgYVNE57U8rmA6rNtvQ2PKJBzdo-Baw@mail.gmail.com> <732644be-b09c-47d4-c776-e91d4f4ceaf5@gmail.com>
In-Reply-To: <732644be-b09c-47d4-c776-e91d4f4ceaf5@gmail.com>
From:   Joel Fernandes <joelaf@google.com>
Date:   Tue, 27 Apr 2021 11:34:07 -0400
Message-ID: <CAJWu+opObFEPSMOH=PxFatCfiSuBL5NJGiiS+UoqCGDfFztLpw@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: Add support for non-qemu VMs
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Apr 27, 2021 at 4:27 AM Yordan Karadzhov <y.karadz@gmail.com> wrote=
:
>
> Hi all,
>
> On 26.04.21 =D0=B3. 21:44, Joel Fernandes wrote:
> > In the below drive link , I saved the .dat files and also share the
> > KernelShark screenshot which still asks me for an offset in a pop up
> > window.
>
> This pop up dialog that asks for the offset is a legacy from the time
> when we have been been doing the calculation of the offset by hand. It
> still can be useful in some specific cases, but the user can do the same
> from the "Tools" menu. It may be better if we disable the automatic
> pop-up when a data file is appended. What do you think?

This makes sense to me. The pop up is confusing. Perhaps you can make
it a menu option if someone wants to inject an offset after the fact.

-Joel
