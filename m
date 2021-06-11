Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D872BC48BE0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Jun 2021 11:04:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C13B861357
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Jun 2021 11:04:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbhFKLGC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Jun 2021 07:06:02 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:37812 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbhFKLGC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Jun 2021 07:06:02 -0400
Received: by mail-wm1-f42.google.com with SMTP id f16-20020a05600c1550b02901b00c1be4abso8417599wmg.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Jun 2021 04:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=G3TRhNo0YUHuZBWnfbfZJwpo8vW+CdPZSRuwSaWidos=;
        b=Yry3ZtMZsWCt9TBbbbYBXCQ2UPDkDpoybETSdvOX399P1SuVcDNpNeFAUdtRw7GWoI
         TPPCEbCYPf7aT6alwb709FRroPx91Memq7UrDQiE0FW2vHeYqUR9jdgjQl9ext7kGRzo
         /MavNPe3o3b9kf5Gr+Dn7shz1g29wTkTxU0KXR8DZ7M9wsCRriDxlKgApc+UcdFwteO3
         QmnYjtwqoLGGuV+xiymHMztIdCGRlLJn7/F+WZzpEZHuxrBASQeJ9kYkNqYR4u84COqn
         zgs+M0oIi7bO2IYagcGLlSocyQ4lF1Tqj5P+s/qo6iLJrbpVHa3rrWFall6jQdI8VAz4
         Z4eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G3TRhNo0YUHuZBWnfbfZJwpo8vW+CdPZSRuwSaWidos=;
        b=qsi6Fl1zqEj1ahi595KWspB5PyqLZ+oqla1ZnXAdb3GLvt8JwmWw+TO9T60grFez4u
         2ZUfZYMy5smICer680ismmm5AtU7SsGsY3Pm2HNO2nqigxySePNUU/XTd5jj+2vW1O29
         JG/rtv0iZYqRmaiPMvAXPT6xXuIBqnuZGtHd4S0QPrRYqcyv320yCja0nA5hKKJ7vq2l
         Ui8Zb6ZkyWOF5dCfBTene8dLN83GefGSn+ikqJXEo8RqyIV8nu5lpF0t/UOgmu2kKnnM
         k8Hcp4vS2PHcjqw10AYglmzNssxSVlOi5or85SJBsDQ0o2Fu9zcd+NVnOmcwLHPIv3g4
         HbqA==
X-Gm-Message-State: AOAM531smPIM22NxFB+RJXJlv5v2owniDgbEZK+pVCrllZl8RN43oNrX
        ZfJ9AdJkdJ1QfAKV+nHr5UmOKb566Aw=
X-Google-Smtp-Source: ABdhPJwae3NpMGb7PgNsVBOz91aR/siG2MP9bw/Gqb9YHXxjLXbyYpywpG9MjBhQritgDA8X+mKEJQ==
X-Received: by 2002:a1c:7918:: with SMTP id l24mr764848wme.126.1623409383614;
        Fri, 11 Jun 2021 04:03:03 -0700 (PDT)
Received: from [192.168.0.109] ([84.40.73.164])
        by smtp.gmail.com with ESMTPSA id d15sm6499768wri.58.2021.06.11.04.03.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jun 2021 04:03:02 -0700 (PDT)
Subject: Re: [PATCH 4/4] libtracefs: Propagate the return value of the
 callback function
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210608135503.12135-1-y.karadz@gmail.com>
 <20210608135503.12135-4-y.karadz@gmail.com>
 <20210609130018.2dd877ef@oasis.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <b218bb7c-6546-ed02-f871-dff3acf79d2f@gmail.com>
Date:   Fri, 11 Jun 2021 14:03:00 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210609130018.2dd877ef@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 9.06.21 г. 20:00, Steven Rostedt wrote:
> [ Sending again, but this time with "Reply-all" to include the mailing list ]
> 
> On Tue,  8 Jun 2021 16:55:03 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> Currently the return value of the callback function can be used to
>> stop pulling data from the trace buffer, however this return value
>> is lost and the user has no idea if tracefs_iterate_raw_events()
>> terminated because there was no more data or because this was
>> requested from the callback function. If we propagate the return
>> value of the callback, this can be used in cases like the one below:
>>
>> int callback(struct tep_event *event, struct tep_record *record,
>> 	     int cpu, void *py_func)
>> {
>> 	....
>>
>> 	return (something) ? 0 : 1
>> }
>>
>> int main()
>> {
>> 	int ret;
>>
>> 	....
>>
>> 	while(ret == 0)
>> 		ret = tracefs_iterate_raw_events(tep, instance,
>> 		                                 NULL, 0,
>> 		                                 callback, NULL);
>>
>> 	....
>>
>> Here the user can effectively terminate the pulling the data
>> from inside the callback.
> 
> With this change, the user can't tell if returned -1 due to an error or
> because the callback ended early, (which is not considered an error).
> 
> The proper way for an application to handle this, is to pass in a
> context structure, and have the callback set a value if it exits early
> or not. I've done this already for needing the same information.
> 
> No change to libtracefs is needed. This functionality is already
> available with the current design:
> 
> struct my_struct {
> 	bool	stopped;
> };
> 
> int callback(struct tep_event *event, struct tep_record *record,
> 		    int cpu, void *data)
> {
> 	struct my_struct *my_data = data;
> 
> 	[..]
> 	if (condition) {
> 		my_data->stopped = true;
> 		return 1;
> 	}
> 	return 0;
> }
> 
> int main()
> {
> 	struct my_struct my_data = { .stopped = false };
> 	int ret = 0;
> 
> 	while (!ret && !my_data.stopped)
> 		ret = tracefs_iterate_raw_events(tep, instance, NULL, 0,
> 					callback, &my_data);
> }
> 
> Now, if you are using this within python, and you want the python
> wrapper to pass data as well, you just need to add that to the struct:
> 
> struct my_struct {
> 	bool		stopped;
> 	func		*python_callback;
> 	void		*python_data;
> }
> 
> int callback(struct tep_event *event, struct tep_record *record,
> 		    int cpu, void *data)
> {
> 	struct my_struct *my_data = data;
> 	int ret;
> 
> 	[..]
> 	ret = my_data->python_callback(event, record, cpu, data->python_data);
> 
> 	if (ret) {
> 		my_data->stopped = true;
> 		return 1;
> 	}
> 	return 0;
> }
> 
> int python_iterator(pthyon_callback, python_data)
> {
> 	struct my_struct my_data = { .stopped = false };
> 	int ret = 0;
> 
> 	my_data.python_data = python_data;
> 	my_data.python_callback = python_callback;
> 
> 	while (!ret && !my_data.stopped)
> 		ret = tracefs_iterate_raw_events(tep, instance, NULL, 0,
> 					callback, &my_data);
> }
> 
> So this patch isn't needed.

I agree. Your solution is better.

Thanks!
Yordan

> 
> -- Steve
> 
