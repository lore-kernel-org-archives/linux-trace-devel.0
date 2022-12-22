Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E2E9C4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Dec 2022 17:36:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiLVRf7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Dec 2022 12:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiLVRf6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Dec 2022 12:35:58 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7E71A227
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Dec 2022 09:35:57 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id h6so1322785iof.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Dec 2022 09:35:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/HrK5ShL4h3BkDN9YctVxJ5YODKBKIvtibQz1ul9WxQ=;
        b=VKL8eyOxAtBbCVLdS8K0CchmUv3LJPu9mfvkMqZbwCi895b4M0lJiyjRa0f3Sl16eN
         nJtTNe3LJQUYVPv1Hf0xGb6s3DUn3eKEVU2eCOFyDyV8hZ+qFLkInUhZkADu2iO5T7de
         VZXjOPDH+z7ILKxDGmn1Gc3rOaZLL9CqDoP+n1AI2tmYuoWjVMdFcXTQ1XIabbKGIP67
         lbtE97hGJLiCMsXuMS2mOJzD+SaMl4TVGOMm6Ev76mitw9Btk+CGX6snWDlpRDPT38z8
         i5kN1z/yXTzc6Elz0/0O/J9wEJr+tTpf+CgXoSuUXcI1oFDA7PW6bY6SzDuoK6pMYbgy
         NKBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/HrK5ShL4h3BkDN9YctVxJ5YODKBKIvtibQz1ul9WxQ=;
        b=55CCkZPt60lnFYeeaxrUbNjAfvJSmf9ARBk6Y9Yp9m/nmfUewLEYhkzPP3DSrCXHgy
         F52N7sFijE0RiRGNkpNVOrZxfM0sxTKtlWKUpDajXHXjLnWtakZFRbVod5UqEd90UkAQ
         72SZ1l2SDyfFlBgvlULoXYJwRQ4WJWaXWMLlPwMFv47PTT9SvuFkiKNYmQWd123ObNnY
         JOJ3R/5Z6rKnB5DiNckKAadfVwWrRp4VZbJc7qnlimfULQNIogO4Yb4zekIL4GRJkyDD
         fI822DRRmqzX12u0ZhMxrEHiTZ1lvf45aHOZtHlqiTNC5lOXqB5zy/+c4dSgyOpgM540
         +ysA==
X-Gm-Message-State: AFqh2kq2EzHPxLWnwai/9kxrIGj7gT4w5lav5n3aw3H0cKX1Az1p2Ijv
        S+uIjv/zuMouN2jwTgt8BS7vhQ==
X-Google-Smtp-Source: AMrXdXsXJcWxwhckZpDtMKUgQqnrpUo2JSOj79Lr5iCTUSQGnJf84nGkTFxWqJJ8wbkJ3Jv9MG3r/g==
X-Received: by 2002:a5e:9204:0:b0:6e0:27a2:1768 with SMTP id y4-20020a5e9204000000b006e027a21768mr4169614iop.18.1671730557085;
        Thu, 22 Dec 2022 09:35:57 -0800 (PST)
Received: from google.com ([2620:15c:183:200:ff89:86b8:e1a6:df49])
        by smtp.gmail.com with ESMTPSA id q22-20020a02a996000000b0038a6d03db70sm245920jam.34.2022.12.22.09.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Dec 2022 09:35:56 -0800 (PST)
Date:   Thu, 22 Dec 2022 10:35:53 -0700
From:   Ross Zwisler <zwisler@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Mike Frysinger <vapier@google.com>
Subject: Re: [PATCH] libtracefs: Make sure 32 bit works on 64 bit file systems
Message-ID: <Y6SVeVrUrfy41Pyy@google.com>
References: <20221221134903.4520c983@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221221134903.4520c983@gandalf.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Dec 21, 2022 at 01:49:03PM -0500, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> As stat() can overflow if a 32 bit user space reads a file on a file
> system that has inodes greater than MAX_INT. Compile with
> _FILE_OFFSET_BITS=64 that mitigates this problem on 32 bit user space.
> 
> Reported-by: Mike Frysinger <vapier@google.com>
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Tested-by: Ross Zwisler <zwisler@google.com>
