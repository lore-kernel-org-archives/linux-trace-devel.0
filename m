Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B47CBC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  6 Jul 2022 11:31:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbiGFLbH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 6 Jul 2022 07:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiGFLbG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 6 Jul 2022 07:31:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 307D725EA7
        for <linux-trace-devel@vger.kernel.org>; Wed,  6 Jul 2022 04:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657107064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7+agReCcm5jknMuxFd1NOmlafXcyNcBcmNobCK4VXC0=;
        b=Z+FSFOOaRLF3DP3CvPh8vgjeLpQoYL32VGrtCdhHrpN6CSuyL4UhIzUmFOSvLrNpAR0yJu
        XUJbur6RsYuF+EM1YAGRZ1Sge9m/xgsCMwYKMxhguVmsEanbUo4p0GuuumAyhmgS9pqlqA
        DGYLOKNjO7JSrUQ2fmmgz7Kjnp141WQ=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-287-3UDrLCf6PfaxGMA-gsN_tg-1; Wed, 06 Jul 2022 07:31:03 -0400
X-MC-Unique: 3UDrLCf6PfaxGMA-gsN_tg-1
Received: by mail-ej1-f70.google.com with SMTP id qf29-20020a1709077f1d00b00722e68806c4so3628074ejc.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 06 Jul 2022 04:31:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:cc:from:in-reply-to
         :content-transfer-encoding;
        bh=7+agReCcm5jknMuxFd1NOmlafXcyNcBcmNobCK4VXC0=;
        b=xWZQIVZoL9gx0AhFxAGwuAaeZk6CeVdhubFX9qBXemk6qMKla/sH3VN/6Nen6YiK9A
         CQFv41v1VN00kjcWlsGnaOV1cps+pPnSI4FEQip8YRDYNAnud9ee8fwc8wug3av9JO/8
         qStkYfCrzfe1h2T9TwtxTroB0TIAl6h/J36+y07jPgkCw0l7Zx2jx+AkQqINe0OD40ad
         4TB3eMYAsjkm+I2Ov7XZ9w8DGJ4G41ho4G+qBarJ17kVLQRxXdb+uODCCqW66QoC7AdV
         1TsiTITFCkwC/e3a4aS7tSm09PHnZNkdOb3PTFYTIQ5GkninlFB4FbzjLfoohbpWbKMr
         1wvw==
X-Gm-Message-State: AJIora8onUcmpE+tKQRcXPpO3uT6gbWK/ijV66x/xE2wnPrE3L9gkL75
        2ssjsjQXWa8LsE8lwKXnyV2zXfi+QV4/I+uZOuum3W01ebicjQB5ZIdZuEJ/LArxXwJ6I2jRdoC
        32dwsnZNFOedTAmng1qruCa7+iJNfOA0=
X-Received: by 2002:a05:6402:524d:b0:43a:72fe:76b7 with SMTP id t13-20020a056402524d00b0043a72fe76b7mr14114797edd.398.1657107061959;
        Wed, 06 Jul 2022 04:31:01 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uKrIGQo+bW3bqTqN2i8HBKCyWHsvCM/4Y+BfPNJnB61ImsP//Nqn0WrCxR+IxpQHTmzlEjGQ==
X-Received: by 2002:a05:6402:524d:b0:43a:72fe:76b7 with SMTP id t13-20020a056402524d00b0043a72fe76b7mr14114779edd.398.1657107061763;
        Wed, 06 Jul 2022 04:31:01 -0700 (PDT)
Received: from [192.168.0.198] (host-80-104-20-93.retail.telecomitalia.it. [80.104.20.93])
        by smtp.gmail.com with ESMTPSA id ec35-20020a0564020d6300b004316f94ec4esm25844708edb.66.2022.07.06.04.31.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jul 2022 04:31:01 -0700 (PDT)
Message-ID: <c8aa45af-9a64-8318-71d6-91511afed8e6@redhat.com>
Date:   Wed, 6 Jul 2022 13:31:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: stopping ftrace on event
Content-Language: en-US
To:     Benjamin Steinke <benjamin.steinke@woks-audio.com>
References: <4044532.36S9Iv5CRb@desktop>
Cc:     linux-rt-users <linux-rt-users@vger.kernel.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
From:   Daniel Bristot de Oliveira <bristot@redhat.com>
In-Reply-To: <4044532.36S9Iv5CRb@desktop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 7/6/22 10:50, Benjamin Steinke wrote:
> Hi all,
> 
> I'm hunting sporadic high irq-handler latencies in a pcie driver by using 
> ftrace. I'm currently using trace-cmd record but get way to large files due to 
> the event being so infrequent.
> 
> Is there a way to stop tracing or dump the current trace buffer when a specific 
> event occurs?

https://www.kernel.org/doc/html/latest/trace/events.html#event-triggers ?

-- Daniel
> Thanks for your help,
> Benjamin
> 
> 
> 
> 

