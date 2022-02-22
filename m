Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BA32C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Feb 2022 06:27:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbiBVG2B (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 01:28:01 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:57674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbiBVG2A (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 01:28:00 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806A598F6D
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 22:27:34 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id qk11so39687573ejb.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 22:27:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=P7o4HxQaOlr9SCGrcjhZ2ak1rSR4bVQBy3BoLtsPZ7g=;
        b=as1pgwpyPiitxhg9Q8gpOZv/hnRLXwHsoESvo1mZ59nEM+KwlaEGA+ie/UYpE+fWxb
         wjDi+lyy7TvfF56E1OVpskneaZgT1dcgbUQAzyfiSw/kZswNzB62baKuiGtu+sYJUC1u
         Oo5GdSReonvrICVr+x5UZQGmLabZOXaDFTtdIWwByZ+r2J0f2FfSvIim6KvxQxuNHs5N
         9rdm+/609sp1zwigRW4e25vMICeXELsY95Kip9/pmet3eSZ9/0WvJ0HWZNYqotONXR8t
         y2ZNNd8DsiUbOCrCshY9302NIgPuwvb3CP4SMxQ2gD/irJXNlrErqkGdVVE4aqdHI5gZ
         d7NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=P7o4HxQaOlr9SCGrcjhZ2ak1rSR4bVQBy3BoLtsPZ7g=;
        b=d+cJ9FGB7SKqV7dovcmF2PExFTF6zXpz41tLPkatF5C+2s7CjlEk5Pe2Azzt8QX0nd
         vbM+YdqShk8tVbMlYocUYd9k/r3c2GcrFCbKBEwoG9wcBHptluqhwtq1XIE6ikKi5+Xu
         LVkmcM/bIFN8wbj/ftN5f9N/97aggaT+KYjSSZ323zSlkcm0No+84IxO5ChYdhNjZydp
         DMiSlIDp41CVTFW6RYfTPIlUw6gjakxACbvgPJktatWAbF++bYEyvhgNLqFs91HIhqlV
         JPxsIvZ+cEWm/NUhleYXcdina1YNVBxugZodnFUjwtYvVFzPOj/mKFtcAy6sHz4U+u87
         L5kA==
X-Gm-Message-State: AOAM5313sVCbiWI3xvZpuz3kPJZAh2qPG96f7yUF9RDD45Qb/uYB046s
        00I03kbLBlGa9zCSH8SxrzI=
X-Google-Smtp-Source: ABdhPJy7J4m4IBjSBhYOdhTenlHecuU7vy8xuQLRQjVA8WQV5sfMXGEmVM4bHlI1Wj9wo1zuqRM31g==
X-Received: by 2002:a17:906:dfd4:b0:6cf:6563:2b98 with SMTP id jt20-20020a170906dfd400b006cf65632b98mr18772687ejc.80.1645511252757;
        Mon, 21 Feb 2022 22:27:32 -0800 (PST)
Received: from [192.168.1.10] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id t22sm7620187edr.55.2022.02.21.22.27.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 22:27:32 -0800 (PST)
Message-ID: <c2b27dce-96fb-176e-51b9-df6f1ce760fa@gmail.com>
Date:   Tue, 22 Feb 2022 08:27:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v1 1/3] libtracefs: Add user_events to libtracefs sources
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>,
        Beau Belgrave <beaub@linux.microsoft.com>
Cc:     linux-trace-devel@vger.kernel.org
References: <20220218225058.12701-1-beaub@linux.microsoft.com>
 <20220218225058.12701-2-beaub@linux.microsoft.com>
 <dba49d0e-cac5-5945-e02e-b45a6d751032@gmail.com> <20220221175720.GA1738@kbox>
 <20220221141625.60a7db50@rorschach.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220221141625.60a7db50@rorschach.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 21.02.22 г. 21:16 ч., Steven Rostedt wrote:
> On Mon, 21 Feb 2022 09:57:20 -0800
> Beau Belgrave <beaub@linux.microsoft.com> wrote:
> 
>>> We've been trying to follow certain naming convention for the APIs and to
>>> provide similar usage patterns for all types of trace events that are
>>> supported by the library so far (dynamic, synthetic and histograms). If
>>> 'XXX' is the type of the event ('user_event' in your case), the pattern
>>> looks like this:
>>>
>>> tracefs_XXX_alloc() - this constructor just allocates memory and initializes
>>> the descriptor object without modifying anything on the system. We allow for
>>> multiple constructor function, in the case when your objects has to many
>>> possible configurations and it is hard to do everything in a single API.
>>> Looking into your implementation, such constructor can do half of the work
>>> done in 'tracefs_user_event_group_create()'
>>>
>>> int tracefs_XXX_create(struct tracefs_XXX *evt) - This is the API that
>>> actually adds your event on the system. Note that it takes just one argument
>>> that is the object itself. Again, looking into your implementation, this
>>> will combine the other half of tracefs_user_event_group_create() and
>>> tracefs_user_event_register().
>>
>> Are you and Steven aligned on this convention?
> 
> I would say you are both correct ;-)
> 
> The problem is, this doesn't really match the other events. The other
> events are created in the kernel, and become a normal event. The big
> difference here is that the event is tested in user space. It will be
> hard to make it match the same criteria as kprobes, dynamic events, and
> eprobes.
> 
>>
>> The request looked slightly different:
>> See https://lore.kernel.org/linux-trace-devel/20220121192833.GA3128@kbox/T/#m2bcf53c373fbeaba2c46d1a053b3174171167e4e
>>
>>>
>>> int tracefs_XXX_destroy(struct tracefs_XXX *evt) This API removes your event
>>> from the system. The first argument is again the object. If needed, here you
>>> can use a second argument that is 'bool force'.
>>>
>>> int tracefs_XXX_free(struct tracefs_XXX *evt) - just to free the memory
>>>
>>>    
>>>> +struct tracefs_user_event_group *tracefs_user_event_group_create(void);
>>>> +
>>>> +void tracefs_user_event_group_close(struct tracefs_user_event_group *group);
>>>> +
>>>> +int tracefs_user_event_delete(const char *name);
>>>> +
>>>> +struct tracefs_user_event *
>>>> +tracefs_user_event_register(struct tracefs_user_event_group *group,
>>>> +			    const char *name, enum tracefs_uevent_flags flags,
>>>> +			    struct tracefs_uevent_item *items);
>>>> +
>>>> +bool tracefs_user_event_test(struct tracefs_user_event *event);
>>>
>>> And maybe "test" is redundant. You can do the check in tracefs_XXX_create() and return an error if it fails.
>>>    
>>
>> Test is required so user programs can tell when write should be called.
>> Otherwise excessive calculations and stack data are pushed for no good
>> reason.
> 
> This is the part I'm talking about.  The "user_event" here is actually
> executed in the application, and this API is to handle it. This is
> where the user events diverge from the other events.
> 
> The user events create the event like any other dynamic event (we could
> look at keeping that part similar with the other APIs). But then
> everything is different.
> 
> When the event is created, the application is given a location on a
> special mmapped page that represents if the event is enabled or not.
> Then the application is to read it *at the event site* to know if it
> should record the event into the ring buffer or not.
> 
> That's what the test is. It's equivalent to the "static_branch" that
> tracepoints use in the kernel, except this isn't a static branch
> (although we could possibly do something like that in the future!).
> 
> The application will:
> 
> 	if (tracefs_user_event_test(event)) {
> 		tracefs_user_event_write(event, ...);
> 	}
> 
> Where if the event is enabled (by an external program), then it is to
> record the events. This is the API that does that.
> 
> And test is not redundant at all.

Thanks a lot for clarifying this and sorry about my confusion!

I have one last question. Do you consider as a valid use case that the library must support, someone to do a just 'test" 
without writing after this, or to "write" without testing first?

thanks!
Yordan

> 
>>
>>>> +
>>>> +int tracefs_user_event_write(struct tracefs_user_event *event,
>>>> +			     struct tracefs_uevent_item *items);
>>>
>>> The "write" is OK.
>>>
>>> Maybe we can change 'tracefs_user_event' to 'tracefs_usrevent' since we already use 'tracefs_dynevent' for dynamic events.
>>>
>>> What do you think?
> 
> Not really. This is closer to tracefs_printf(). But thinking about this
> more, perhaps "write" is a bit confusing as we use it to write to
> tracefs files.
> 
> What about:  tracefs_user_event_record() ?
> 
> As this is exactly what it is doing. It's recording the event.
> 
> 
>>>    
>>
>> I'm happy to do whatever, I just want to ensure you and Steven are
>> aligned.
> 
> Thanks!
> 
> -- Steve
