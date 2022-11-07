Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0F63C4332F
	for <linux-trace-devel@archiver.kernel.org>; Mon,  7 Nov 2022 14:27:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbiKGO1Z (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 7 Nov 2022 09:27:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232548AbiKGO1D (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 7 Nov 2022 09:27:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66BC827FCD;
        Mon,  7 Nov 2022 06:20:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A03B6104F;
        Mon,  7 Nov 2022 14:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB45C433B5;
        Mon,  7 Nov 2022 14:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667830841;
        bh=AwlZonmYoSagHAdZq3BTugX4OMvuo8eQJXbQG7hNrD8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=HKvEUUqAJyQoTVRDFUnTOs9iRfRVsTiLkkb5Ubje4UkWZDNiD95aWBlmvcGuWjPIl
         6Peb161GQ0SJVS+HUrDTbUb6/U4Y7Uj9flDWiGEtCilpw4r6qTyDUiO9NAJYl/mC34
         zgEJTIJbmCOQwMq2Wj8qs86b3ZO5sGWA9dkO/ddKKZURVg2rEPDnHhK/QHGUBFJlh0
         xaq1Obpkx6EJVh/zmIlmJ4anUSnpyV/fYFtPT1WGvgeM/v6osQJ8m8KubwqR0XYipG
         7L/uebj04vV4TmgV9WDkKBeNu42QS4lQSoKfkWVR7L2ySew+GYvquvYtj1CggP5coZ
         MyppttBNjkIoQ==
Message-ID: <364685cb-da5f-f4f3-92cf-7b638ba96f8c@kernel.org>
Date:   Mon, 7 Nov 2022 15:20:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] rtla: Fix exit status when returning from calls to
 usage()
Content-Language: en-US
To:     John Kacur <jkacur@redhat.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        Chang Yin <cyin@redhat.com>
References: <20221103135742.9523-1-jkacur@redhat.com>
 <b4639b19-94e3-2128-643e-6a3a44a1d944@kernel.org>
 <ca3dce1a-98d0-109a-f4d-d35b6ee2399a@redhat.com>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <ca3dce1a-98d0-109a-f4d-d35b6ee2399a@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 11/7/22 14:53, John Kacur wrote:
> 
> On Fri, 4 Nov 2022, Daniel Bristot de Oliveira wrote:
> 
>> On 11/3/22 14:57, John Kacur wrote:
>>> rtla_usage(), osnoise_usage() and timerlat_usage() all exit with an
>>> error status
>> missing .
> ?
> 

rtla_usage(), osnoise_usage() and timerlat_usage() all exit with an
error status.

and so on...

-- Daniel
