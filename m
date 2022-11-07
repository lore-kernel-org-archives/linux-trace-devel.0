Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AA66C433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon,  7 Nov 2022 13:54:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbiKGNyk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 7 Nov 2022 08:54:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbiKGNyj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 7 Nov 2022 08:54:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662201CFCC
        for <linux-trace-devel@vger.kernel.org>; Mon,  7 Nov 2022 05:53:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667829218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WZNc+tr+S4WltVfB/kdnQZ3LcaOHN70GuE/UfxpNBH8=;
        b=E9wH+hvpIluezlAv3ZC7JfVuKZjnzWwAXhHLBW0fx3qySjIqKe/kO8WcdrWUARanOn4djR
        t1r0UsCoynzzuiMJWwdmPsic8IE4RtI9fvK9FRXGg1r0wQCk5UiPS715Bm5FLdcoKGdzdx
        JIuGHh97J0mR/Fd156r/Uz/aDMD4pso=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-184-uRFHSljENoGebJDm4X7Zjg-1; Mon, 07 Nov 2022 08:53:35 -0500
X-MC-Unique: uRFHSljENoGebJDm4X7Zjg-1
Received: by mail-qk1-f197.google.com with SMTP id x22-20020a05620a259600b006b552a69231so10084631qko.18
        for <linux-trace-devel@vger.kernel.org>; Mon, 07 Nov 2022 05:53:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WZNc+tr+S4WltVfB/kdnQZ3LcaOHN70GuE/UfxpNBH8=;
        b=hg8YlPkQDlGSBgWph9jpVVsYEApBU3MhLnpf+B3b6/F9zC3ssv/vAJpYYNKxsNaBtd
         A8jrWyJRpZe8yFluNKUESTNhMEdg60oBOezrDvmu7zaorK3hqFtg2EKet9yl5PC4KhIK
         nGLwBDKMfSLRlVyyEhJY8u8QSb145ogL4H7JN/faEcYkLWCgbm5RsNJK3L/08eQLBlAY
         ZkLNLObEBJ0UPeOwXdNH2fNBDy3DBlTHu0pY4wsctSqFYMm8Wm/G1s6QIA6PVPjrje6l
         L/GQ0bGnaj4oVF6Y4KuKxCIcuVWSVrgtKhVkSbfZP9CNP+rdsBssEghDdEcnzhPazhI8
         4Maw==
X-Gm-Message-State: ACrzQf2SznS+/82c99blgvZZOKGHGWRqTM0oxopCYbN8OJ7ocrRBVqa+
        7C1I2vl7AKpm5BiUGFjst1Fgrzv0zDmt6HytzbMnnN48vVi8Cy2RQ/zRDdHNIwcsXHMSxjND1od
        vPPIofDJH00UEHUNkqClqrxrEjJ9OeiM=
X-Received: by 2002:a05:6214:1cc8:b0:4af:649f:dd57 with SMTP id g8-20020a0562141cc800b004af649fdd57mr44979888qvd.81.1667829214987;
        Mon, 07 Nov 2022 05:53:34 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7fwKhFvTzfCmWtOrLqIbBb5uJr/E5Ez/tctluYNT+hrC/s+ClMa3HLULqX7VxpE9UhnsGjmA==
X-Received: by 2002:a05:6214:1cc8:b0:4af:649f:dd57 with SMTP id g8-20020a0562141cc800b004af649fdd57mr44979873qvd.81.1667829214841;
        Mon, 07 Nov 2022 05:53:34 -0800 (PST)
Received: from fionn (bras-base-rdwyon0600w-grc-08-184-147-142-10.dsl.bell.ca. [184.147.142.10])
        by smtp.gmail.com with ESMTPSA id r4-20020ae9d604000000b006fa2b1c3c1esm6805488qkk.58.2022.11.07.05.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 05:53:34 -0800 (PST)
Date:   Mon, 7 Nov 2022 08:53:20 -0500 (EST)
From:   John Kacur <jkacur@redhat.com>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>
cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        Chang Yin <cyin@redhat.com>
Subject: Re: [PATCH] rtla: Fix exit status when returning from calls to
 usage()
In-Reply-To: <b4639b19-94e3-2128-643e-6a3a44a1d944@kernel.org>
Message-ID: <ca3dce1a-98d0-109a-f4d-d35b6ee2399a@redhat.com>
References: <20221103135742.9523-1-jkacur@redhat.com> <b4639b19-94e3-2128-643e-6a3a44a1d944@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On Fri, 4 Nov 2022, Daniel Bristot de Oliveira wrote:

> On 11/3/22 14:57, John Kacur wrote:
> > rtla_usage(), osnoise_usage() and timerlat_usage() all exit with an
> > error status
> 
> missing .
?

> 
> > However when these are called from help, they should exit with a
> > non-error status.
> > 
> > Fix this by passing the exit status to the functions
> 
> missing .
?

> 
> > Note, although we remove the subsequent call to exit after calling
> > usage, we leave it in at the end of a function to supress the compiler
> 
> suppress?
Of course, thanks for the spelling check!

> 
> > warning "control reaches end of a non-void function"
> 
> missing .
?

> 
> Yep, that is a problem, and agree with the solution (I am already doing it
> in the rv cmd line).
cool

> 
> -- Daniel
> 

