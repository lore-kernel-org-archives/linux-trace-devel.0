Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11FA5C433F5
	for <linux-trace-devel@archiver.kernel.org>; Sun,  3 Apr 2022 14:56:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiDCO6O (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 3 Apr 2022 10:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359128AbiDCO6I (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 3 Apr 2022 10:58:08 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122B125C72
        for <linux-trace-devel@vger.kernel.org>; Sun,  3 Apr 2022 07:56:14 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id gi14so5708741qvb.0
        for <linux-trace-devel@vger.kernel.org>; Sun, 03 Apr 2022 07:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=pfAG2c3zsA5WYMV6re7vFna8313bquO3ucLdwhMXwTg=;
        b=bHfGYoRSEAHJ9iXUMpXPm0M/UbeY1H70OEWC8/6v6VtLfIcu2rakwpCbGwK7BdP4Dg
         8xAMeeow0KOYtKo3qMNOfh0rO9MgvlvJegDJpsQuK81cyP/wBb1Z+H83viK+sSL5XE62
         1Rw2Eue+0ZSi+x4oBDR9+UIaEkiPTGB+78Yb4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=pfAG2c3zsA5WYMV6re7vFna8313bquO3ucLdwhMXwTg=;
        b=n4JBxMHMwgdzX37lYgeZAkORsPeVqqq5GsXJ6e24pLCVaEsOmLBrk2cnTgu+LH5ZeN
         GJ0CljohSL73MSAlymVOQLJ/sef5Qw1tevO5JdsoX0cQDpmshxDx1Fv55QH/QZ57zmS3
         EThMe3A2ewUj9uGYo7oyA0yG7URDXK9ojl8kU3WDQzc1kjyLIkaBDEbVFLmSOL9epBKg
         5IEVNuCRd8Fg29Tje5+/w8TfMGHSoIekwelS5/aS6plEGVBZwrY/jEPqifm2OSqP88JH
         /NSNepQl0fST6UJClEQJR1YptyE8BH4dphzFIGM81qAqnj2PWHKK3otiv6a/+cBeEFLl
         FbMQ==
X-Gm-Message-State: AOAM532GYELu17Am6vWL5dzRkBMCPURrWB4GMUl3TozqnGQ652KucvJR
        1uu7iLUZmjRgvHE637HHzvEAlg==
X-Google-Smtp-Source: ABdhPJyOMhP1jJwY0plYTXBx2kcjyoZtiQM7niJV/kSNd+rx15DB7BJ5WT/AcLaB1LET/wj7AUz40w==
X-Received: by 2002:a0c:f18a:0:b0:443:ce3d:542f with SMTP id m10-20020a0cf18a000000b00443ce3d542fmr3500075qvl.106.1648997773246;
        Sun, 03 Apr 2022 07:56:13 -0700 (PDT)
Received: from localhost (228.221.150.34.bc.googleusercontent.com. [34.150.221.228])
        by smtp.gmail.com with ESMTPSA id p64-20020a37a643000000b0067d9afad07asm4731643qke.76.2022.04.03.07.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 07:56:12 -0700 (PDT)
Date:   Sun, 3 Apr 2022 14:56:12 +0000
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, rostedt@google.com,
        vineethrp@google.com, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH] trace-cmd: Try alternate path for message cache
Message-ID: <Ykm1jBpdD0+NjsTW@google.com>
References: <20220329191801.429691-1-joel@joelfernandes.org>
 <20220401153737.7c444426@gandalf.local.home>
 <CAEXW_YQxPgaKOMhDy8kVdaT9esvY8ctP1Mfw3RZXwkJkTYhh0w@mail.gmail.com>
 <20220401190629.32564bd2@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220401190629.32564bd2@gandalf.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Apr 01, 2022 at 07:06:29PM -0400, Steven Rostedt wrote:
> On Fri, 1 Apr 2022 15:50:10 -0400
> Joel Fernandes <joel@joelfernandes.org> wrote:
> 
> > export TRACECMD_TEMPDIR="/data"
> > 
> > That’s fair. What about using memfd for this, do you feel that’s
> > reasonable? I have not yet measured how big this file gets but if it’s
> > small enough that might work too.
> 
> Is this a separate question? That is, do you mean using the above
> environment variable *and* then use memfd?
> 
> I believe that the cache is used for passing the compressed data from the
> guest to the host. I don't think it will be more than one compressed chunk.
> 
> But Tzvetomir would know better.

Hey Steve,
No its the same question. Instead of temp file, I was proposing in-memory
file using memfd_create(2), that way no hassle as long as the file is not too
huge.

Also looks like my patch is incomplete anyway, I need to change
tracecmd_msg_handle_cache() as well.

I'll try to write up a patch with memfd unless you guys disagree.

Thanks,

- Joel

