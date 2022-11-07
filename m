Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDDDFC433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon,  7 Nov 2022 15:40:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232428AbiKGPkU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 7 Nov 2022 10:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232248AbiKGPkT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 7 Nov 2022 10:40:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D1A1F9F9
        for <linux-trace-devel@vger.kernel.org>; Mon,  7 Nov 2022 07:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667835560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FbangJEJrbXgXqHJdhlq4R8fIkEkN66BXotud0VPUA8=;
        b=UTFcA2p5ABWDbjbHZ1n7DA05mbPEVTjgKFLFMTyAI951VtYWZ+fU0Cbg2NGaK3HI7yfTtl
        0pp2KSXaCUv12DQNKzTErR5XzH0wOJBjHJlMb88HqEDKjNAtIInUfF4kQIp3a8zPPjhutR
        8DljkxHIFxcNMV+V12mTCz5tXD41lt8=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-321-jqTi5QAjNYaEDqCpgoFujA-1; Mon, 07 Nov 2022 10:39:18 -0500
X-MC-Unique: jqTi5QAjNYaEDqCpgoFujA-1
Received: by mail-ed1-f70.google.com with SMTP id b13-20020a056402350d00b00464175c3f1eso8620068edd.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 07 Nov 2022 07:39:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FbangJEJrbXgXqHJdhlq4R8fIkEkN66BXotud0VPUA8=;
        b=cnYKFbuJ0kgO0ZrDyWkNtgIznnK5zEF3wh5mMZfxfE74i04QCkLJhT5whaE6cahdrs
         1PKcNYImLwdGz4irUvrNfVFIzAYNLT7YvKZakqCRNY9AqJay1g+qqCf7g/y8OYzh0uEO
         jpBkDLYOXNqmjTFxO7eEF8mAmwTCMWf+Zycc46ysxMHbLy85Lzzlf9eoePn3h9Z5Qss9
         yZmjcjSdwD4eIZFM2OEBYnJxzAeyM5k/wbPgzOoyZDJRWsxBFDaUzt73Y8hZJ0Vasn6u
         2RLq/Uh/PN03irW6Li5LRXJOp4DhCfDFvknjAx0ISEQngnUqukOzhCE7eIsf+QQJ2oCx
         OfDA==
X-Gm-Message-State: ACrzQf3lMZZqVqTlT4X+ay7hJoCbgwiTe4yiVijEv/IRQUAzeIP9nSCq
        Ibvg+uKLcj5rk1tOMj/8TcXDEdjJ9WkY9Cam2clU6VqQAfREYlwBoyHqW2eaGO/cChnDKSQbIt9
        hgoviuf7XpLTEYuWj3WkQKpl+j5zR168=
X-Received: by 2002:a17:906:8a47:b0:7a3:86dd:d33b with SMTP id gx7-20020a1709068a4700b007a386ddd33bmr49288294ejc.67.1667835556907;
        Mon, 07 Nov 2022 07:39:16 -0800 (PST)
X-Google-Smtp-Source: AMsMyM42A3zHo2QHCCnHvmWMgIPyOHhFQwigkSk3YswDJwOV6fLcIgR0QfuMfeivQAYv33WAjFrKqg==
X-Received: by 2002:a17:906:8a47:b0:7a3:86dd:d33b with SMTP id gx7-20020a1709068a4700b007a386ddd33bmr49288269ejc.67.1667835556655;
        Mon, 07 Nov 2022 07:39:16 -0800 (PST)
Received: from [192.168.0.46] (host-87-10-24-76.retail.telecomitalia.it. [87.10.24.76])
        by smtp.gmail.com with ESMTPSA id ca12-20020a170906a3cc00b0079800b81709sm3570235ejb.219.2022.11.07.07.39.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Nov 2022 07:39:15 -0800 (PST)
Message-ID: <624afa7a-3b9a-29a3-ab33-1b0efee83c19@redhat.com>
Date:   Mon, 7 Nov 2022 16:39:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH V2] rtla: Fix exit status when returning from calls to
 usage()
To:     John Kacur <jkacur@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        Chang Yin <cyin@redhat.com>
References: <20221107144313.22470-1-jkacur@redhat.com>
Content-Language: en-US
From:   Daniel Bristot de Oliveira <bristot@redhat.com>
In-Reply-To: <20221107144313.22470-1-jkacur@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 11/7/22 15:43, John Kacur wrote:
> rtla_usage(), osnoise_usage() and timerlat_usage() all exit with an
> error status.
> 
> However when these are called from help, they should exit with a
> non-error status.
> 
> Fix this by passing the exit status to the functions.
> 
> Note, although we remove the subsequent call to exit after calling
> usage, we leave it in at the end of a function to suppress the compiler
> warning "control reaches end of a non-void function".
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>

Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>

Thanks!
-- Daniel

