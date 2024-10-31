Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 226A1198E8C
	for <linux-trace-devel@vger.kernel.org>; Thu, 31 Oct 2024 09:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730368122; cv=none; b=Vo8hkK0rPxqe8Gs9v01fne9BZ7ulnwY4QrPx1hE7LQ5ZHzBOTGcEGdYJdVYTZ9xl57m98dhrCvKFw4g1yP5R2bjJJ9hsPODYVc42t0kKUoe5YQ/Wq/zIGgtFfXZXjJmpoHBPKwXP9Tk44kClJm6PcwLcNef2faqTO0aEW6mU4W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730368122; c=relaxed/simple;
	bh=id5rfJn/1gqZg8BQeU9G6tba6kHlGAM+uIWvXgSVLp0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ibWX+zYWsghtrSh4ntkPtbzMlflfKmwv0mmmE+c0FlBI3AGrSqgqXocYnRi/aUfSOlc3ptxZgyhUN717yJjVc1h4OuMsKWMEtXaCfSpuhxbyhN6foIi8oUw/OnaEfvIiJJ375853KwDcNZF9wyMMi9Q9bmpNG+blnhVzKqoO008=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2F0EC1063;
	Thu, 31 Oct 2024 02:49:05 -0700 (PDT)
Received: from [10.57.24.116] (unknown [10.57.24.116])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AF5A63F66E;
	Thu, 31 Oct 2024 02:48:34 -0700 (PDT)
Message-ID: <d95d6af4-75bb-44da-a479-045556141559@arm.com>
Date: Thu, 31 Oct 2024 09:48:32 +0000
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] trace-cmd: libtracecmd: Rename private functions to fix
 static building
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org,
 Douglas Raillard <douglas.raillard@arm.com>
References: <20241028122247.1594967-1-metin.kaya@arm.com>
 <20241030204731.69d656d8@rorschach.local.home>
Content-Language: en-US
From: Metin Kaya <metin.kaya@arm.com>
In-Reply-To: <20241030204731.69d656d8@rorschach.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 31/10/2024 12:47 am, Steven Rostedt wrote:
> On Mon, 28 Oct 2024 12:22:47 +0000
> Metin Kaya <metin.kaya@arm.com> wrote:
> 
>> Building trace-cmd statically fails because of duplicated symbols for
>> strstrip() function which is also implemented in libtracefs. The
>> __hidden attribute does not resolve these conflicts for static builds
>> due to the lack of namespacing support in C. Refer to the associated
>> Bugzilla page [1] for further details.
>>
>> Although only strstrip() breaks the static build as of now, we should
>> fix the underlying issue comprehensively across the libtraceevent,
>> libtracefs, and trace-cmd packages. The recommendation on [1] is
>> prepending package name (e.g., "tracecmd_") to private functions (tagged
>> with __hidden attribute).
>>
>> Thus:
>> 1. Retain private functions which already start with "tracecmd_".
>> 2. If a private function starts with "trace_", then just change its
>>     prefix to "tracecmd_".
>> 3. If prepending "tracecmd_" prefix to a private function's name clashes
>>     with an existing one, rename one of the functions per its context
>>     (e.g., rename trace_load_plugins() to
>>     tracecmd_load_plugins_from_handle() and trace_append_options() to
>>     tracecmd_append_options_to_file()).
>> 4. Prepend "tracecmd_" prefix to all remaining "__hidden" functions.
>>
>> Future __hidden functions should follow this prefixing schemed to avoid
>> new naming conflicts.
> 
> I'm not against the change to make the hidden functions with a unique
> name, but I rather come up with something other than "tracecmd_". That
> prefix was to be used for functions that will eventually become public.
> 
> Would "tcmd_" work?
> 
> Same goes for the other libraries. The "tracefs_" is for functions that
> should be exported. Perhaps rename it to "tfs_"?

Hi Steve,

Ah, you are right. Those prefixes conflict with public ones. Perhaps I 
misread the discussion on Bugzilla page. I've no objection to using 
"tcmd_", "tfs_" and "tep_" prefixes. Will update all three patches 
accordingly.

> 
> As for libtraceevent, it doesn't need a separate prefix for local
> variables compared to exported ones, but that prefix is "tep_" and not
> "traceevent_".

I believe I did not rename any variables in the libtraceevent patch [1].
However, I made the following changes in the libtracefs patch [2]:

-extern const struct tep_format_field common_stacktrace;
+extern const struct tep_format_field tracefs_common_stacktrace;

-extern pthread_mutex_t toplevel_lock;
+extern pthread_mutex_t tracefs_toplevel_lock;

Do you recommend keeping them as is or using "tfs_" prefix?

[1] 
https://lore.kernel.org/linux-trace-devel/20241028122105.1594296-1-metin.kaya@arm.com
[2] 
https://lore.kernel.org/linux-trace-devel/20241028122143.1594614-1-metin.kaya@arm.com

Thanks,

