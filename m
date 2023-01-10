Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5350C54EBC
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Jan 2023 13:57:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbjAJN5G (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 10 Jan 2023 08:57:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238460AbjAJN4j (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 10 Jan 2023 08:56:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F24E7CBF0;
        Tue, 10 Jan 2023 05:55:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17E51B81670;
        Tue, 10 Jan 2023 13:55:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53BFC433D2;
        Tue, 10 Jan 2023 13:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673358906;
        bh=4FpepVm+jtZECaf1mR2jEgtjhF01RkAVhjObCVRWMPY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=hmeUBySoAI+SBnKFP0Bp/ZlJDXc3PZsA1xzou2EFMg8AhqfQRkHvvv1gLX/QIpg50
         3qXPFxyEO/GDLNbcCHjtGPLL+MmIpzTM947dogzZoStQQloQFxosMDLILuIelhtK3t
         s5lzxb6y2LeJINxBFTv33SxHMEXGyEmAzy75ZKdOxFAj7RM45CxV/ZTXw2Vm6zzI4s
         2G5Twiau3gmCKEMlzSSxRT9pGszfvsiCVkdsycibo3ZH2GNMM8gT0NJiigQX4G7sS+
         lZVDQmgbyXd1Q1KrPavBGR0FkredVwp/Nhi13fm1NPbf2fX3P32VjIEsijVYZN4I/f
         R/K1uCTLxt74w==
Message-ID: <42d1e999-79a6-94dc-cc88-77520ddce068@kernel.org>
Date:   Tue, 10 Jan 2023 14:55:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] tools/rtla: Explicitly list libtraceevent dependency
To:     Daniel Wagner <dwagner@suse.de>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230110131805.16242-1-dwagner@suse.de>
Content-Language: en-US
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <20230110131805.16242-1-dwagner@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 1/10/23 14:18, Daniel Wagner wrote:
> The current libtracefs.pkg file lists the dependency on
> libtraceevent ("pkg-config --libs libtracefs" -> "-ltracefs
> -ltraceevent").
> 
> Dan Nicholson's Guide to pkg-config[1] stats that "Libs: The link
> flags specific to this package and any required libraries that don't
> support pkg-config". Thus the current libtracefs.pkg is not correct.
> 
> rtla is depending on libtraceevent but it doesn't express this in
> 'pkg-config' part to retrieve the correct build flags.
> 
> In order to be able to update the "Libs:" section in the libtracefs
> project we need to list the dependency explicitly to avoid future linker
> failures.

I am ok with it. Steve?

-- Daniel
