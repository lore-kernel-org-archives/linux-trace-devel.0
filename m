Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29520C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Apr 2022 14:11:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234826AbiDHONN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Apr 2022 10:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236723AbiDHONM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Apr 2022 10:13:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 678C634CA0D
        for <linux-trace-devel@vger.kernel.org>; Fri,  8 Apr 2022 07:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649427067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zqy0/ETekPLWIA7UmgVZ0eT5yPuRDnDxC9XVs/Ymk8c=;
        b=SFJXRJbZKwWdFsgifIPtH4UgtlWg6AIxbwaoU89f1YCPlpSsrKJHedT/ZbHGnbL/glUYnH
        vwZQPWFWLC9ZjHmF7TC0Z/K1bmiUipmppvoGoE+3wdaF/sBjVGll+SyBTo2olaXaUuH98Q
        WkpNdX+HszANLNr9bcMTqmIryjDlXRE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-47-O0fJ903ONiyM9Y_TuWjVkQ-1; Fri, 08 Apr 2022 10:11:06 -0400
X-MC-Unique: O0fJ903ONiyM9Y_TuWjVkQ-1
Received: by mail-ed1-f72.google.com with SMTP id p14-20020a05640243ce00b0041cbccbe008so4681523edc.16
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Apr 2022 07:11:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zqy0/ETekPLWIA7UmgVZ0eT5yPuRDnDxC9XVs/Ymk8c=;
        b=hrBhbipeGo9y0KZ+w1SqBq4NpogxH29leYZaaQNnmPjNgD7RbmuCKKKu3IjDnB48iz
         UdwjERyuRQNwcDOMuIUwKoG55lQ7PPMoLXdbP1wWgSbAhpKlNkkfg4wPJa93qL7MO2Kc
         ikpFFaxMv7kTf+xXMQwU5jOeYbBMjCmEdcCXkuni4QMUYQLvgFQd7JltxVJelqokGuOQ
         9ziHv4kPJxlT1JMsjK9Lt98YsU8bwfsiIS+Dl95yKnKpnpWqWTYRpSoCvfrPmofLzsWY
         nexKyIBwH1ewurRYVPXtUFv9E3FAjjKtvnzqJIx6Ljj2PEPxJy4q1TBMqV2Re0L4L6tW
         OovQ==
X-Gm-Message-State: AOAM530HetFxrJ84UOeItXL9z9L0uAvhNkz+uLV1Cvts7jc+DEhGbK+5
        ti44xjdMB4e99FuPHpUWuI8DT52eM8X/GRTGbq2nhK8PV94LUxqfMCvexs0et6O912Z1n7ElyVE
        iC3eY6nOZpg3C+RvNthydq4v+9/PuBPo=
X-Received: by 2002:a05:6402:d7:b0:413:673:ba2f with SMTP id i23-20020a05640200d700b004130673ba2fmr19804697edu.29.1649427064778;
        Fri, 08 Apr 2022 07:11:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxz2QYbOAS6gQvm5hSttLC55Jx/uzKl8NPt10gwYa8XKd5lkS0jIF6mruPngPWmHh2Ot4kDoA==
X-Received: by 2002:a05:6402:d7:b0:413:673:ba2f with SMTP id i23-20020a05640200d700b004130673ba2fmr19804684edu.29.1649427064609;
        Fri, 08 Apr 2022 07:11:04 -0700 (PDT)
Received: from [10.0.0.45] (host-95-245-33-130.retail.telecomitalia.it. [95.245.33.130])
        by smtp.gmail.com with ESMTPSA id gg7-20020a170906e28700b006e73ac96f99sm6694825ejb.224.2022.04.08.07.11.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Apr 2022 07:11:04 -0700 (PDT)
Message-ID: <36540bb7-ada0-451b-f935-a3a1f9c83d41@redhat.com>
Date:   Fri, 8 Apr 2022 16:11:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 2/2] rtla: Minor fix to grammar in README.txt
Content-Language: en-US
To:     John Kacur <jkacur@redhat.com>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
References: <20220402043939.6962-1-jkacur@redhat.com>
 <20220402043939.6962-2-jkacur@redhat.com>
 <24f79a7c-0146-ad0a-988a-608edd402faa@redhat.com>
 <6b8d24c-d793-866c-30a7-f015c7babd2d@redhat.com>
From:   Daniel Bristot de Oliveira <bristot@redhat.com>
In-Reply-To: <6b8d24c-d793-866c-30a7-f015c7babd2d@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


>>> -The rtla is a meta-tool that includes a set of commands that
>>> +The rtla tool is a meta-tool that includes a set of commands that
>> I do not like bike-shedding but 'the rtla tool is a meta-tool" sounds repetitive.
>>
>> Does:
>>
>> The rtla meta-tool includes a set of commands...
>>
>> sound good for you?
>>
>> -- Daniel
>>
>>
> Perfect
> 

Would you mind re-sending this patch?

You will also need to adjust the paragraph alignment as the first line is
shorter now ...
-- Daniel

