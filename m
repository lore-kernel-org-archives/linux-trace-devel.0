Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82AD0C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Nov 2022 16:33:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234086AbiKKQdL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Nov 2022 11:33:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234128AbiKKQdK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Nov 2022 11:33:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6235483682
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Nov 2022 08:32:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668184332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F2aMgNrmGwKwBaWad+YX98Mrt+mogZ0kg4N8L1HjPf0=;
        b=JTGVTAvMip7Sa2Y3uf/f1W6f0NrBXPrRUa0vGPi+aNwxCR6uO0CwHLR2gy/mKdjw5UXdaI
        3cRGhbKvL3Rk1KpEiMIHGXQu2r/eNJ6oJP+oR/Y32ZKt+2zGQHkdmXV5k7DMHyD2uUPZ5y
        aUk0WukcheQrAzfR+QVv0ay138dL4pY=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-592-pfK5QsidPj-7zkq2YAr-nQ-1; Fri, 11 Nov 2022 11:32:11 -0500
X-MC-Unique: pfK5QsidPj-7zkq2YAr-nQ-1
Received: by mail-qv1-f72.google.com with SMTP id mb6-20020a056214550600b004bc0f14f7b2so3948085qvb.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Nov 2022 08:32:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F2aMgNrmGwKwBaWad+YX98Mrt+mogZ0kg4N8L1HjPf0=;
        b=KTJBEhgkqS/si5BB1P03Cnv0ELegrS5NIl14ha0C4bIs5mF7oaMaLwOta4Pi3hAWZP
         EA+numzglhaCcKbx2D7ms+LibhMqmV+xVLgsgDYSB7zR5n73xwjFAEPd3HaRluIWB0IN
         VMeuY3q9X8EuiHVmdnsGGKBlNozWpIcNBhG9/1TZfQl80aNXxTuubNfxaQlwGJnfWcGd
         tI7BP61ZtgPVIUNBADzyPzxjt6fG9HyOBE4bLIcw85KSNxF+4sCJfTJNFKuKuCsWBY8m
         AH0AF6O4cQYQuvo/vK/1kOCq7LWL90Lva/1aMSFwznnG3DaqWpeKW+5nRfCHCy3bafJi
         k50w==
X-Gm-Message-State: ANoB5pl7CujGNnA+yPVSHHRtFxz37KmZA3PX05uDtaoqdpPG+VInxBkG
        qch9enmRGB5lPpVfEBZ7TRPOO50a6XvwVXWngPHisUbkQPKGS29SCP5Fn/aa0jjUC7ZCiX/P+qq
        NYXXa4yNXPJ255WUwn8n+Eh78M5jOjuE=
X-Received: by 2002:a37:95c7:0:b0:6f8:3f8f:e629 with SMTP id x190-20020a3795c7000000b006f83f8fe629mr1654399qkd.684.1668184330649;
        Fri, 11 Nov 2022 08:32:10 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6UJlvo5WW+4eVxe52el69/zcvA5/DwtZ7h5zAHsgU5UMyslv39VfxOqXLHt4ERvp2X8ZGufA==
X-Received: by 2002:a37:95c7:0:b0:6f8:3f8f:e629 with SMTP id x190-20020a3795c7000000b006f83f8fe629mr1654393qkd.684.1668184330450;
        Fri, 11 Nov 2022 08:32:10 -0800 (PST)
Received: from vschneid.remote.csb ([154.57.232.159])
        by smtp.gmail.com with ESMTPSA id v65-20020a379344000000b006e54251993esm1597530qkd.97.2022.11.11.08.32.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 08:32:09 -0800 (PST)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Douglas RAILLARD <douglas.raillard@arm.com>
Subject: Re: [PATCH 1/2] libtraceevent: Add boiler-plate code for cpumask types
In-Reply-To: <20221109190634.1fd9200d@rorschach.local.home>
References: <20221018151630.1513535-1-vschneid@redhat.com>
 <20221018151630.1513535-2-vschneid@redhat.com>
 <20221109190634.1fd9200d@rorschach.local.home>
Date:   Fri, 11 Nov 2022 16:32:03 +0000
Message-ID: <xhsmhedu9zc3g.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 09/11/22 19:06, Steven Rostedt wrote:
> On Tue, 18 Oct 2022 16:16:29 +0100
> Valentin Schneider <vschneid@redhat.com> wrote:
>
>> @@ -3484,6 +3498,11 @@ process_function(struct tep_event *event, struct tep_print_arg *arg,
>>              free_token(token);
>>              return process_bitmask(event, arg, tok);
>>      }
>> +	if (strcmp(token, "__get_cpumask") == 0 ||
>> +	    strcmp(token, "__get_cpumask") == 0) {
>
> Hmm, not sure what the difference between the above two are.
>

One makes sense, the other doesn't :-)

That's a copy/paste fail, the second one wants to be "__get_rel_cpumask"

> -- Steve
>
>> +		free_token(token);
>> +		return process_cpumask(event, arg, tok);
>> +	}
>>      if (strcmp(token, "__get_dynamic_array") == 0 ||
>>          strcmp(token, "__get_rel_dynamic_array") == 0 ||
>>          strcmp(token, "__get_sockaddr") == 0 ||

