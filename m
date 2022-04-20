Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD047C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Apr 2022 15:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359477AbiDTPUL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 20 Apr 2022 11:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357191AbiDTPUK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Apr 2022 11:20:10 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D26E544A13
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Apr 2022 08:17:23 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id 12so2020926pll.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Apr 2022 08:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=pq6AeRCHdPeKem1ci5wrS/xJb51fo4Tmmhi+NkjnUnw=;
        b=m+BvwfEx1xVK/2wmLOYETGvh/mrZxnCAFfaKkrXAsDoDF1QypifBzgpfk1u0smxXee
         zLLOeAXXP0O6kRh0ACIQLO38sMac67SEuX+U9dzJ+lAsKz7Mtk9Xgt6vFygL/4gQzf/5
         HDjkuTzHOgaDcRiIIoBsmAjNkG/mTgJEaONBMF8glAJg4cg+SJ90qOiKvu4qjqed+ZvJ
         ZWESmAMLCbnf3NaUbLmDHH0kFSe264cLhEoF1vQROsOoalYRxMBLjUzzhki/l6KxSdba
         C1gMKcGFqZ1a7LA5igDKFhmWKfRdWhmgbrYzmFmTqZ4ATHA4lXW9BPHlwFLw5ssSl+4I
         0EmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=pq6AeRCHdPeKem1ci5wrS/xJb51fo4Tmmhi+NkjnUnw=;
        b=BmZEBfkNg/pe9cAWPCaKw/z5SOrD2tUwYQUPTzFGqVd0957193tc5vAMDDDYgFZ/bi
         klXXEDNsjcwxdiwzQVqaLAiJwvZBgHrraU/9yy+DYlZfJvuogKbvV3pNIyue1HJ575no
         9uJ8CkKFNS3eZct2HNc8qIp+fEnZxSW2TWTzAcnKSqlExbIqte28NiwBen5lsfnSPY6I
         GcBwuaHVvAbghfB2tivMz+XeSDTxIZGYzvr//vaKEon1r1vdD55JTwerZMmuzLu+5f+8
         QYTFMd2/XEWCqV7KRruxfQKKU50WximTNzH60R4AjutH64bKCdSKrKigrQoK4ZnUkR25
         T5Og==
X-Gm-Message-State: AOAM532pR4xCpGAHwLk06zBWJr8RoFXYfP5032zB8fht5fjHvQdaHXDh
        BbfswJlsHu8HYJmvp3yw7uE=
X-Google-Smtp-Source: ABdhPJxnlm4NY3zR4LeBbi/FHvTHS72LzwST9Oc3HGe6HTY0IVo03Icr+S+Qm7opTJgmBgxENJOb1g==
X-Received: by 2002:a17:902:b488:b0:156:509c:5c42 with SMTP id y8-20020a170902b48800b00156509c5c42mr21187782plr.2.1650467843288;
        Wed, 20 Apr 2022 08:17:23 -0700 (PDT)
Received: from ArchDesktop ([14.100.48.186])
        by smtp.gmail.com with ESMTPSA id s190-20020a625ec7000000b005061c17c111sm20637634pfb.71.2022.04.20.08.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 08:17:22 -0700 (PDT)
Date:   Wed, 20 Apr 2022 23:17:20 +0800
From:   Solomon Tan <wjsota@gmail.com>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: Kernelshark v2 all-black plots area
Message-ID: <YmAkAE+5wy2mLncD@ArchDesktop>
References: <89dbef38a1050c31390ce263d51fff1f72a42164.camel@suse.com>
 <ce06b82f-6335-4653-0d27-e48a37ffb5aa@gmail.com>
 <Yl9WBztqKGD0PpmJ@ArchDesktop>
 <146d751e-eb40-52f8-fbd1-3dc2627d03f9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <146d751e-eb40-52f8-fbd1-3dc2627d03f9@gmail.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Apr 20, 2022 at 11:06:49AM +0300, Yordan Karadzhov wrote:
> Hi Solomon,
> 
> There are few things you can do.
> The way KernelShark build finds the font file is by running the following command in a shell:
> 
> fc-list FreeSans |grep FreeSans.ttf | cut -d':' -f 1 -z
> 
> So run the same command in a terminal and try to figure out why it fails.
> If it fails because the 'FreeSans.ttf' does not exist, you can manually provide a path to some other font file to be used.

It failed because FreeSans was installed in my system as otf instead of ttf hahaha.
> 
> cd kernel-shark/build
> ./cmake_clean.sh
> cmake -DTT_FONT_FILE=/path/to/some/font/YourFont.ttf ..

Thank you! This command worked. I just specified the path to the otf
file instead of the ttf file, and it worked like a charm. kernel-shark
is installed and working well!

I actually faced another issue as well - which was that the compilation
appeared to be successful but kernelshark was not made at all because
FreeSans was missing. So the black plot I got was from the one I
installed from the package manager. But now I have kernelshark installed 
from your github so all is good now :). 

I would like to propose some changes to the CMakefile in light of my
experience. I will send them in reply to this email shortly. For your
consideration, please :).

Thank you!
Cheers,
Solomon
> 
> Please let me know if this works.
> Thanks!
> Yordan
> 
> 
> On 20.04.22 г. 3:38 ч., Solomon Tan wrote:
> > On Tue, Feb 09, 2021 at 03:06:14PM +0200, Yordan Karadzhov (VMware) wrote:
> > 
> > Hi Yordan!
> > 
> > I have the same issue of an all-black plots area.
> > 
> > > Ciao Dario,
> > > 
> > > There is a bug in one of the patches from the last patch-set I sent. This
> > > bug was reported by Tzvetomir. My guess is that you are hitting the same
> > > issue. If this is the case you must also have an error message saying
> > > "Unable to find FreeSans font".
> > 
> > I have the same error message. I tried installing the `gnu-free-fonts`
> > package on Arch, but it does not get rid of the error.
> > > 
> > > You can manually do the fix suggested by Tzvetomir (see his reply to [PATCH
> > > 15/24] kernel-shark: Update KsDualMarker and KsGLWidget) or just get a
> > > corrected (rebased) version of the code from
> > > https://github.com/yordan-karadzhov/kernel-shark-v2.beta
> > 
> > I tried installing from your github repo, but the same error still
> > shows. I have all other dependencies installed. FreeSans is the only
> > complaint from the cmake .. command. Is there another potential fix I
> > could try?
> > 
> > > 
> > > Please let me know if this fixes your issue.
> > > Thank you very much for testing and reporting!
> > > 
> > > Best
> > > Yordan
> > 
> > Thank you!
> > Cheers,
> > Solomon
