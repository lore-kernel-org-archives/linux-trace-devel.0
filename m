Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01D84C4338F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 23 Jul 2021 00:03:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C45D860EB9
	for <linux-trace-devel@archiver.kernel.org>; Fri, 23 Jul 2021 00:03:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232682AbhGVXW2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Jul 2021 19:22:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30394 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232550AbhGVXW2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Jul 2021 19:22:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626998581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B+oocyA+C8Pzpd05UbR4hWj/f52ZM0WyGxU07j0tjKE=;
        b=N3C12KoHVRbZhtOCJpr002y1s3Fj0J0qxVlqiD4EirXsh1izk1OClem+oBFSneYc6+myLI
        l6Ob80F/oWxkICJakVMlbF+HFsSKtsK9YNLjbHZEGbM1R0DD0UQTTDRlqMNrXCVzjvgTUW
        3/EmXwME7nq68Dsf+wkPt47WmYS6UHk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-ATvyCCZOPNO6KiRv_Q2p4Q-1; Thu, 22 Jul 2021 20:03:00 -0400
X-MC-Unique: ATvyCCZOPNO6KiRv_Q2p4Q-1
Received: by mail-ed1-f71.google.com with SMTP id cw12-20020a056402228cb02903a4b3e93e15so3558510edb.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Jul 2021 17:02:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B+oocyA+C8Pzpd05UbR4hWj/f52ZM0WyGxU07j0tjKE=;
        b=LsAo96rI0Xu+6WN1VelYUTrOf980Z2bEGfp8p58lTpjK9b1V4/gigTAijVSvDPIP8e
         V6N/2aHMA+pfjDnKdPxdA+OJFDaDf2YyA/TBpE2FAISPd7IijMUkPmf1XBEPsj0RqGr9
         7EJSRu+IYRHuju62s7cHViTMOG3knD915MIpDioireo/gujpdJun396DGMKTzb9Fw0PK
         7oASKwf8r4vMBT9X/977HsIoiduZcpUB/uB5dysWsfSKyAJ4qgA16PO512WSA4u0C9Wg
         wvSIFm8jzJeTmiu+v0BhGjMpgD7HL8MfolVeYHVmZMavA+CXVizxSskXKYBkBBGQt3mV
         U6CQ==
X-Gm-Message-State: AOAM531mL963mTBGgmRXiFUhr9bdo83DLOLg8M6qczyySLnYQAAkYdP2
        XU1uTj3Y9TQc2NzZqps5pgTsc/7uY2n8dJ/2+SLz9LlrsCCtMSeM7vfN6+6icSsI0yOKWTApfy+
        9lSYxw8a/3+yyw273TkJZylKVKZ2GCSokLjOfUeUWvFER/UWNaQgp/e6DyuLBo3jwwRJCAb1PiP
        BdERPHdQ==
X-Received: by 2002:a17:907:7ba7:: with SMTP id ne39mr2109825ejc.467.1626998578890;
        Thu, 22 Jul 2021 17:02:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyKoEsCHJ5UX95xLJS2YhScTTFFkAuumxqOTDoMZMiIhYAbQMHVZu1LlcQZA7cif7/76De8bA==
X-Received: by 2002:a17:907:7ba7:: with SMTP id ne39mr2109810ejc.467.1626998578733;
        Thu, 22 Jul 2021 17:02:58 -0700 (PDT)
Received: from x1.bristot.me (host-79-37-206-118.retail.telecomitalia.it. [79.37.206.118])
        by smtp.gmail.com with ESMTPSA id g8sm13139592edw.89.2021.07.22.17.02.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 17:02:58 -0700 (PDT)
Subject: Re: [PATCH] libtracefs: Add Requires libtraceevent to pkg-config file
To:     Steven Rostedt <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
References: <20210722155435.773e91ec@oasis.local.home>
From:   Daniel Bristot de Oliveira <bristot@redhat.com>
Message-ID: <f7d4e1b4-2cf6-324e-9c8d-838cf841a7ce@redhat.com>
Date:   Fri, 23 Jul 2021 02:02:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210722155435.773e91ec@oasis.local.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 7/22/21 9:54 PM, Steven Rostedt wrote:
> From e0e16d1a16749dccd3c00261e6dcb78f2e55e8ec Mon Sep 17 00:00:00 2001
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> Date: Thu, 22 Jul 2021 15:44:55 -0400
> Subject: [PATCH] libtracefs: Add Requires libtraceevent to pkg-config file
> 
> If a developer uses libtracefs only, they should not need to know about
> libtraceevent just because libtracefs requires it.
> 
> The pkg-config pc file has an option to handle such cases, called
> "Requires:". Utilize this feature so that users using libtracefs only need
> to do:
> 
>   CFLAGS = `pkg-config --cflags --libs libtracefs`
> 
> And not:
> 
>   CFLAGS = `pkg-config --cflags --libs libtracefs libtraceevent`
> 
> As with the Requires option, pkg-config now produces:
> 
>  $ pkg-config --cflags --libs libtracefs
>  -I/usr/local/include/tracefs -I/usr/local/include/traceevent -ltracefs -ltraceevent
> 
> Reported-by: Daniel Bristot de Oliveira <bristot@redhat.com>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

it works!

Tested-by: Daniel Bristot de Oliveira <bristot@redhat.com>

-- Daniel Bristot de Oliveira <bristot@redhat.com>

