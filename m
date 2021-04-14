Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEB80C433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Apr 2021 09:26:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89DAC613C8
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Apr 2021 09:26:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232979AbhDNJ0i (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 14 Apr 2021 05:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347844AbhDNJ0X (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 14 Apr 2021 05:26:23 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A77C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 14 Apr 2021 02:26:00 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id w4so15424933wrt.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 14 Apr 2021 02:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=X8q3FgByrSYOUKQf7zOaaQGPFDPjXNgMRbp5mslJlTI=;
        b=Zf2nMU+As937UO+s2oZvogr/m8q7qVZZNdMAzRhwnLX/uNuCCLNH/uIDhU8ccpBucc
         2Z/FV4rYQlBMSe986tmKDVVE/6rnFmPGgx3MAGpyt3hoZnSVQQXHuScyK5kVEWxMhrMm
         VXQrUE+PorrIA8vnSEJ0fwzUVdGx086TPxe7/1lVBOJRtR34ERCDXVi2O7/Uud00vQfe
         N3dV+nIddzRSpDm++SZXRCnPj2jazZo+HDM34a7coKP6lcqhtCu9V7epH5rg5G4X5sBA
         Yt5uaiOwBsVG1onlZjsg4kAYyqZMfulS3CP0lMWfevJwZ7gkJ0N8VMj2865owpWhXmmU
         iJuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X8q3FgByrSYOUKQf7zOaaQGPFDPjXNgMRbp5mslJlTI=;
        b=S7feia8BEXoQ3wsQTTO1kY3h7qxErXesRR/dgGnAN05YT29+UEiwDIExAmFIaLqX28
         DHr+1gRFahrw2bZscR39Md7nVVyZMGnjlywDFQ2Br5bA3PtsBhdulBIe3O1av6S616YR
         0u5bIuA4rYqgitMlSQ/K22etFb4WzQl8d05o4GN+HtQe9hyQ9D2NfsD0fSbboAHTCN68
         6RDrzPqrDoguRyZ25MNeOoUNfRrSl1LkNO/X9AUgtHLAHEyFquP+Bsf86vBk1ZgvKM6C
         S8dAg1MN0hIqEHA6tehnw8XH3p/5xQjt53Sm9pESltuuvN2iiTD+9+j26+9k76p/xGOT
         TTFw==
X-Gm-Message-State: AOAM5316kz294mKBkGic1MtnOFwBaSd6gK6yEAcQoowNHbzNeRV2geJF
        X+U7OjmAeVxH0VK+Na131f/tkBDvOq2VGA==
X-Google-Smtp-Source: ABdhPJxtAHP+Bj4eAj+RP55I3r/5fkmKFZUWLkb1RgkSaI4Qa0KurGlBD3h/byGfoeOLOE/PwqPutA==
X-Received: by 2002:adf:ea09:: with SMTP id q9mr5221153wrm.235.1618392359416;
        Wed, 14 Apr 2021 02:25:59 -0700 (PDT)
Received: from [192.168.0.109] ([95.87.199.115])
        by smtp.gmail.com with ESMTPSA id n2sm5743675wmb.32.2021.04.14.02.25.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Apr 2021 02:25:58 -0700 (PDT)
Subject: =?UTF-8?Q?Re=3a_A_KernelShark_plugin_for_Xen_traces_analysis_?=
 =?UTF-8?B?4oCL?=
To:     Giuseppe Eletto <giuseppe.eletto@edu.unito.it>,
        linux-trace-devel@vger.kernel.org, xen-devel@lists.xenproject.org
Cc:     Dario Faggioli <dfaggioli@suse.com>,
        Enrico Bini <enrico.bini@unito.it>
References: <CALTQNB5X1+G33Qoh5nNxttQe_GkzKvJFLfEXQszsc6XYr+NgUA@mail.gmail.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <8b43ae47-9d7e-a95c-4573-852d09f99662@gmail.com>
Date:   Wed, 14 Apr 2021 12:25:57 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CALTQNB5X1+G33Qoh5nNxttQe_GkzKvJFLfEXQszsc6XYr+NgUA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Giuseppe,

It is great to see such progress in the development of the Xen plugin.

Can you share with us what are your plans for continuing this work. Is 
this a first prototype of the plugin, or it is an almost final version?

I was also thinking that maybe you can prepare a short tutorial on 
writing KernelShark plugins for data inputs. You have the best 
experience for this task, since you are the first to develop an external 
plugin. Ideally, this can even turn into a talk that you can give at 
some open source event.
What do you think?

Best,
Yordan


On 13.04.21 г. 17:28, Giuseppe Eletto wrote:
> Hello,
> I want to share with you a new plugin developed by me, under the
> supervision of Dario Faggioli, which allows the new version of KernelShark
> (the v2-beta) to open and view the Xen traces created using the "xentrace" tool.
> 
> In fact, KernelShark is a well known tool for graphical visualization
> Linux kernel traces, obtained via "ftrace" and "trace-cmd". Anyway thanks
> to its modular architecture, it is now possible to implement plugins which
> open and display traces with arbitrary format, for example, as in in
> this case, traces of the Xen hypervisor.
> 
> For more information on how to build the plugin and/or
> to view the source code I leave the repository below:
> https://github.com/giuseppe998e/kernelshark-xentrace-plugin
> 
> 
> In short:
> 
> $ sudo apt install git build-essential libjson-c-dev
> $ git clone --recurse-submodules
> https://github.com/giuseppe998e/kernelshark-xentrace-plugin.git
> $ cd kernelshark-xentrace-plugin/
> $ make
> 
> $ export XEN_CPUHZ=3G # Sets the CPU frequency ((G)hz/(M)hz/(K)hz/hz)
> $ kernelshark -p out/ks-xentrace.so trace.xen
> 
> 
> You will need the development version of KernelShark, available here:
> https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git
> 
> A screenshot of the plugin in action is available here:
> https://github.com/giuseppe998e/kernelshark-xentrace-plugin/raw/master/.github/img/ks-xentrace.png
> 
> I'm happy to receive whatever feedback you may have about it,
> and to answer any question.
> 
> Kind regards,
> Giuseppe Eletto.
> 
