Return-Path: <SRS0=wnl5=DG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76C96C4727C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 13:44:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 162BF207C4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 13:44:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WiBBQDBH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729822AbgI2Not (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 29 Sep 2020 09:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728346AbgI2Not (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 09:44:49 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A250C061755
        for <linux-trace-devel@vger.kernel.org>; Tue, 29 Sep 2020 06:44:49 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id m34so3909499pgl.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 29 Sep 2020 06:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=gm+sTU1jZMWE0ZVk1ajjaZXjBOSqCh6GPsWeEoBupXY=;
        b=WiBBQDBHty2yrERYRcmJO2qktS33F8ptxR7TkHPMosjz2fzRgn5h5vlXeaw4KMh0bz
         uOH8mRo/SpK3JFk1xEVATWNeeLE/hm+e6k+5vKEVpwNj6vXG7UgN5C+h0fv3B4iPg/jS
         Za3aeG1KGItpcrIbbff3+h6yDvsQYjGyydyXKQzfvOAGZgXmaOgKl5l9dfpkRcx0CetP
         CmM9oh7c3EKLz9bTTgL0lLMGg3oCD7rTwn8+a2T3uMunItYeaLLhMUuaK97WK0FnCFk/
         HwVKPB6SeMih2RKaRuxCbDZKfn2ZF4F+jsua1yKLYYtlgDgNzNgFeGbhrClQ6TZtnhbB
         Rhnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=gm+sTU1jZMWE0ZVk1ajjaZXjBOSqCh6GPsWeEoBupXY=;
        b=mm+BucmbiTrNX08tiDOPtmy46uN2Beyax1GhEHGHLdb+6w6UiQ9sJkDXNrNB8nlS+U
         11DELfOyaiQ7epZuU2PyNpx2sF5gO1JAqrZpZQFvPCxyKXDk5JtKREKRCsOmHaV3urZo
         AA58btgT/5Mzv2WPQINS9B9IfodbHVyjTZcOv1ayy4uHlLDEgiEL/zrKat+0GW7O+UE5
         FCflzPKd7lauHuJQQuv3Gro5nydMyqkpV1R+ZhAAebb8sXe21w18mEX34wK7VcoDPG0A
         sRmYcmItDYcNT4efaqUoi0wDcZJjlQPMlHwm841Gr86NBXs/oZhHapIxwa4sK5aOCih0
         /SYg==
X-Gm-Message-State: AOAM530z7nSTp9ddADodNwe37khnEwJpttqjXxAuDqmSgVP7WWqcsbyr
        iI3c6sr4gmDkv51GrvSf7lf+h7W5HS3u/Q==
X-Google-Smtp-Source: ABdhPJxJVz4Sf19osl2lBRhDnwFsRnJgco5GxXu2mxCF0TVzmZHjMXPUHkdZ2tH+UniTmr8672aqkQ==
X-Received: by 2002:a17:902:be0c:b029:d2:8ceb:f39c with SMTP id r12-20020a170902be0cb02900d28cebf39cmr4590031pls.71.1601387088832;
        Tue, 29 Sep 2020 06:44:48 -0700 (PDT)
Received: from i7.zsun.org (h150-66-46-238.ablenetvps.ne.jp. [150.66.46.238])
        by smtp.gmail.com with ESMTPSA id a1sm2227352pjh.2.2020.09.29.06.44.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2020 06:44:48 -0700 (PDT)
From:   Zamir SUN <sztsian@gmail.com>
Subject: Co-existing of traceevent of trace-cmd and perf
To:     linux-trace-devel@vger.kernel.org
Cc:     tstoyanov@vmware.com, Jiri Olsa <jolsa@redhat.com>, zsun@redhat.com
Message-ID: <1baba359-fd07-1a61-0158-e65c6b06425f@gmail.com>
Date:   Tue, 29 Sep 2020 21:44:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi,

I'm packaging trace-cmd 2.9 into Fedora.

Back in trace-cmd 2.8, all the plugins are under 
$(libdir)/trace-cmd/plugins. While as of trace-cmd 2.9, I find the 
traceevent plugins are installed in $(libdir) by default. This brings up 
an interesting situation - the perf tool also contains a copy of the 
traceevent in the same directory. So this means trace-cmd and perf have 
file conflicts. In terms of packaging, this means users can only install 
one of them, not in parallel (at least for Fedora). So I'd like to see 
if there are existing proposals or suggestions for which one is expected 
to be used by other utilities? Or is there any official plan to move one 
of them to the other directory?

I'm copying Tzvetomir and Jiri as I think you're the first people for 
getting the plugins in this directory for trace-cmd and perf respectively.

Thanks in advance.

-- 
Zamir SUN
Fedora user
GPG : 1D86 6D4A 49CE 4BBD 72CF FCF5 D856 6E11 F2A0 525E
