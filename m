Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE8AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Apr 2022 00:38:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358584AbiDTAlV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Apr 2022 20:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358579AbiDTAlU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Apr 2022 20:41:20 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020C61AD83
        for <linux-trace-devel@vger.kernel.org>; Tue, 19 Apr 2022 17:38:35 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id v12so295419plv.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 19 Apr 2022 17:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eUqk3ZRJdztZudE8Op7LFP/PRkwmqSlom+Tv4Hgf+SE=;
        b=WkhUoSl8ujoS9ryLjCOTk0bYW13JtumXHiXU3nS/Dj8xbhyPmvR7y85zjA21qaR4m0
         Q3i+y0zJ4oFwvG+mpyw/Q+6lfTrDWJKPmT40uhusmoOSKtRN9352aOHz7KNJCGF09a52
         ns7UVL3dHWs/PLkhML99zFpBAjjt0b5i7nuC69hn2ASpaYBF/DUPy747ofd1wqGmUqPt
         Eg/VZD3D5GS3z/IMrXvo1gOAniEb3VzrXEL8eNsQ5wwOEJjstIjz8jVwI0/uX9WFmmVo
         7g/RdsGQkkXN9WgW3NNPg3Id56MINEMFP4SxmolyVt9uojQtfX9bhHoU4ZLIec/5yJsV
         vtvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eUqk3ZRJdztZudE8Op7LFP/PRkwmqSlom+Tv4Hgf+SE=;
        b=xkeh3kiu8KSAFpvNMXEfFE2KAmbos0g5wXDyFAL3LYS5tMn1547XHm9QqcpRuHizBv
         ZbuOvhG09LRARAHfYPD4HBG9rDodlH2jLSiVUzBGqDCluGDwyEvIqdCvwUdHP/booCQG
         oE3Qez2VB1b4kENqdgaVk/m5HEi98ucb9wW2yXc4fkEUq7fUN8VnHauemuSKR53U/ZqF
         NArd1NE9NNWnRpQmodAcamvtTOLlZ8LnOTnVVT2Q1QFXgW4RvoK6qY74G9AzjzYAxqGh
         9NhOfm0vFGUcm0IaCbmIKRzIWfKVj6P3pEz7RvKuiAj1AmbfR3lJA0xr7EMeZQR9eCwR
         gjVQ==
X-Gm-Message-State: AOAM530upz6GNGP5KBpNznbFOPaFozKjA021kQ+PDLVdQIBrJ9OP2ZUp
        o7SDSm4E/S2J+uG34buUmq+KakEAAEY=
X-Google-Smtp-Source: ABdhPJwptKppW06YbLEaUxUbyhN7vnv6oD6n8Gab+7RE0Zn5JNUEftMmc8zlgf9QrNHqOZuh89vPYA==
X-Received: by 2002:a17:902:9b87:b0:156:bf3e:9ab5 with SMTP id y7-20020a1709029b8700b00156bf3e9ab5mr17990631plp.119.1650415114397;
        Tue, 19 Apr 2022 17:38:34 -0700 (PDT)
Received: from ArchDesktop ([14.100.48.186])
        by smtp.gmail.com with ESMTPSA id k11-20020a056a00168b00b004f7e1555538sm18488502pfc.190.2022.04.19.17.38.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 17:38:34 -0700 (PDT)
Date:   Wed, 20 Apr 2022 08:38:31 +0800
From:   Solomon Tan <wjsota@gmail.com>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     dfaggioli@suse.com, linux-trace-devel@vger.kernel.org
Subject: Re: Kernelshark v2 all-black plots area
Message-ID: <Yl9WBztqKGD0PpmJ@ArchDesktop>
References: <89dbef38a1050c31390ce263d51fff1f72a42164.camel@suse.com>
 <ce06b82f-6335-4653-0d27-e48a37ffb5aa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce06b82f-6335-4653-0d27-e48a37ffb5aa@gmail.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Feb 09, 2021 at 03:06:14PM +0200, Yordan Karadzhov (VMware) wrote:

Hi Yordan!

I have the same issue of an all-black plots area.

> Ciao Dario,
> 
> There is a bug in one of the patches from the last patch-set I sent. This
> bug was reported by Tzvetomir. My guess is that you are hitting the same
> issue. If this is the case you must also have an error message saying
> "Unable to find FreeSans font".

I have the same error message. I tried installing the `gnu-free-fonts`
package on Arch, but it does not get rid of the error.
> 
> You can manually do the fix suggested by Tzvetomir (see his reply to [PATCH
> 15/24] kernel-shark: Update KsDualMarker and KsGLWidget) or just get a
> corrected (rebased) version of the code from
> https://github.com/yordan-karadzhov/kernel-shark-v2.beta

I tried installing from your github repo, but the same error still
shows. I have all other dependencies installed. FreeSans is the only
complaint from the cmake .. command. Is there another potential fix I
could try?

> 
> Please let me know if this fixes your issue.
> Thank you very much for testing and reporting!
> 
> Best
> Yordan

Thank you!
Cheers,
Solomon
