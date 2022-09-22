Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F9D1ECAAD8
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Sep 2022 02:56:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbiIVC41 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Sep 2022 22:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiIVC40 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Sep 2022 22:56:26 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CEBD91D07
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Sep 2022 19:56:25 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id y2so5469197qtv.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Sep 2022 19:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=NsM8+RUow/Qt+h1ZaBF5FZg+1M/B6tubOjT8C6fKiw4=;
        b=njNiRuSc72RzMBY4WVlNasQUyq4v8Isg4JtZaOeU+2Pg+XTTYZOt9sMUYKMsTb9M+6
         iQEt5oNajP0BlUXItD9Q3eW+h/0DVfKGXz/kLYJTpB3EKFixkViO0a9dnDrja01coFk8
         2TU8M9fQ722jif7A30GoZHiMEVxc42zzWceDw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=NsM8+RUow/Qt+h1ZaBF5FZg+1M/B6tubOjT8C6fKiw4=;
        b=d8RSc10nojlw39iI38CRWTxaWOxQywSnQvoQJ+KeOSLzV3LiVQ+pMhqtj9H7dnXYXu
         WnoFjKdrYs4TgvIsawGhPM6FMa/mcNHM8V/zaUMORvUc/oX0kQ6JNrgsHyWbGfQJ581p
         nXwjWuv6jDhUl0agDW7C+kYAmsJSpOx9l80drkh+hBAH1GdRBfZXS6DM5W9JrWKVotaQ
         xLNituznb3aBDzQsBcxjCRp480xx4n3jipANjj8x/vk8XQM/PExildH8kZa1y9dUkJkQ
         oRcTz9T4oCpkPWjlB0k9z2Fmr4iny7Re1iLkK4oNGq6WJsUpF3VY+/njkV87JAR1XySF
         kt0w==
X-Gm-Message-State: ACrzQf2CkCxkWnF2VMVgbsY4mbxzdenEfcd03c9QoG+jmPeaoz4owAS0
        BI9EQWPXi5BZnqCo+NfKPjKPfj9vpbz9dQE0
X-Google-Smtp-Source: AMsMyM7RJUih7IwEMk/Z8RZ6plDkis7G0BIW4/tw3a5X0uvxEjayP1cxzYmKJ4gb6QDHCViR/io/Cw==
X-Received: by 2002:a05:622a:138c:b0:35c:e9d2:8d76 with SMTP id o12-20020a05622a138c00b0035ce9d28d76mr1172236qtk.463.1663815384707;
        Wed, 21 Sep 2022 19:56:24 -0700 (PDT)
Received: from [10.0.0.40] (c-73-148-104-166.hsd1.va.comcast.net. [73.148.104.166])
        by smtp.gmail.com with ESMTPSA id w23-20020a05620a0e9700b006cbdc9f178esm2946790qkm.25.2022.09.21.19.56.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Sep 2022 19:56:24 -0700 (PDT)
Message-ID: <e39486a0-7093-9914-56a7-3519f60dd1c6@joelfernandes.org>
Date:   Wed, 21 Sep 2022 22:56:23 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH 2/2] trace-cmd: README: Add note on installing libtracecmd
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20220815031342.775201-1-joel@joelfernandes.org>
 <20220815031342.775201-2-joel@joelfernandes.org>
 <20220921214351.1547ed52@gandalf.local.home>
From:   Joel Fernandes <joel@joelfernandes.org>
In-Reply-To: <20220921214351.1547ed52@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 9/21/2022 9:43 PM, Steven Rostedt wrote:
> On Sun, 14 Aug 2022 23:13:42 -0400
> "Joel Fernandes (Google)" <joel@joelfernandes.org> wrote:
> 
>> This might be obvious but it still took me some Makefile reading. Add it
>> to README to make it easier for others.
>>
>> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> 
> Both patches applied. Thanks Joel!

Thanks!

 - Joel
