Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05674C4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Dec 2022 17:35:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiLVRf1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Dec 2022 12:35:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiLVRf0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Dec 2022 12:35:26 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE9C20349
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Dec 2022 09:35:25 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id g20so1337375iob.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Dec 2022 09:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LJLZ1r7SJWB9ElNQn4BwO9J6qicM3g8Qw49BOxtitJI=;
        b=oE8ZaRe37reht0qNQ6b3J6r1sl/7ZmQkvaOSgMx1n+hnKp0JDtj8yBBE1rUFxfz1Wq
         7BPqoAFnkt6h8lJJKUfUT7gRtCmKmqWF6SMDF50zMKAwgMAa8MdH/JB2GXeNvDii/mKk
         Vm1/1B4qrsVCCV/rd9VsmlDWzm8tl3XIbQYsNdTgi3avOc9Gj0VAK04C/+78XgpbeKSM
         ciWOiuf+CE6EBUE16Z15BXJI+L6T+lwVxpIc6/Ih9KQgBXfb+HOn8UOI++bY5emFpYVM
         AC9bSU+tKqvkyQLdhx0N38QHwtoFwHrVB6a4qz81F06ZGk33BcVfSRFdfd2n1s7WpYVS
         bzfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LJLZ1r7SJWB9ElNQn4BwO9J6qicM3g8Qw49BOxtitJI=;
        b=CM0p7VC1a5+WoMdDqKkM4VXyPFxJy5RY8JKDSeIEDSc60A2tdjP+pSP73Z8gz06+qI
         YyDJK5vQ6R7iP50EMYee6oKDV5lRD+kzP7XxAlyxgl8f2WZR4/nwF5Lrc1LjbmYkPt1E
         ZL1Wio0Tf2htCn5/pIgC3LL8rdybW59qrs1AHZCIcqRcxnzvMv1zEeQ6ws5yk1u7akGZ
         CBr0kmrLXyv83YecN6FdfMkvKTnh3YT4r1GGJznAozbqoYK+tv/KbokYqJg2BJErQ3fp
         PY92A/vgkm/fFFSp6mBsg24uOpwtqja9WxlOmb3JG1vEJEZ2X7sB40WaG0WyRGRUFi63
         kddQ==
X-Gm-Message-State: AFqh2kolPw4lvn2hGWxwlgM4Ua3HFhCSOn2qbnVnZu2mA0MN9O+f33bm
        PSuHCmxTPQBEikdBnaPejSB6fqOJNrg/wtXX
X-Google-Smtp-Source: AMrXdXuH0A7yaiIoodrduDvawGm9rCEi2g4yY/SM5vOlqO3sj+Ea8oRN1Vylqzv8OauBmJ011fnx3w==
X-Received: by 2002:a6b:3f46:0:b0:6e0:3535:90ab with SMTP id m67-20020a6b3f46000000b006e0353590abmr13355631ioa.5.1671730524461;
        Thu, 22 Dec 2022 09:35:24 -0800 (PST)
Received: from google.com ([2620:15c:183:200:ff89:86b8:e1a6:df49])
        by smtp.gmail.com with ESMTPSA id n28-20020a02711c000000b0038a3b8aaf11sm259740jac.37.2022.12.22.09.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Dec 2022 09:35:24 -0800 (PST)
Date:   Thu, 22 Dec 2022 10:35:20 -0700
From:   Ross Zwisler <zwisler@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Mike Frysinger <vapier@google.com>
Subject: Re: [PATCH v2] libtraceevent: Make sure 32 bit works on 64 bit file
 systems
Message-ID: <Y6SVWNV4ULu+NLg0@google.com>
References: <20221221134051.53aad658@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221221134051.53aad658@gandalf.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Dec 21, 2022 at 01:40:51PM -0500, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> As stat() can overflow if a 32 bit user space reads a file on a file
> system that has inodes greater than MAX_INT. Compile with
> _FILE_OFFSET_BITS=64 that mitigates this problem on 32 bit user space.
> 
> Reported-by: Mike Frysinger <vapier@google.com>
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Tested-by: Ross Zwisler <zwisler@google.com>
