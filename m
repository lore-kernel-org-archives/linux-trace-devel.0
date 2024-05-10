Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE7E131192;
	Fri, 10 May 2024 08:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715328651; cv=none; b=orNP6AtHHKL7uDRaHLBrmmGUVj7fn7WpET0yFV2KvFqxZewppAafUNu8Til6bmMh4DA14ff1YZuOP/7iVl6o7g+IZ8fxAtpxF+yx1bzlXqTf07TzABtqPqVPj9maO4pIV5OzRlFvOjsLtonICdsIzNU2SxCtQAB2ypG1V/W5FBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715328651; c=relaxed/simple;
	bh=ssf9Iev4stgbN7TAdwZopVFc09VyaC1stjJzZv6XHi8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=EbHNmkjzr3DlQzUAa7zALFABUSxNWuWEXTjGU5aMP+2XBa1I5MqBBcTAdeGEZ7Zgb2U3yxUiyVl2kXZHV6NYGvS3fjvVkDkFdPmrHAmbNLrdlkp0xseMje+OtzmMzsmwgZ3OXbSSfbJ4E4XWBJg0c4fMCHfgj+UhcT+znpuu4R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tVZ9F3Gr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tVZ9F3Gr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8184C113CC;
	Fri, 10 May 2024 08:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715328651;
	bh=ssf9Iev4stgbN7TAdwZopVFc09VyaC1stjJzZv6XHi8=;
	h=Date:Subject:To:References:From:Cc:In-Reply-To:From;
	b=tVZ9F3Grp/f0quLHZq8e5wKEvMEIANtDPBzPn3iGEeocJHnT4tC4FB+7Y2waDQDsi
	 NMAeydiMdfeT5/FbUA3v2sKWm3182DekxVbSer/5lcmJPxjyu1VUqMp89WgIUv5jO3
	 2FKcJpoZMgwLZ8gdGb7ttA07Vyq26S6xlKOEGGk0fUo/zUjjRkhnEmPvom259BNDCe
	 dzSMai9vqfVERa2WP9251MTlMBeeRY7LWFJdT6bqHno2m3FMCPiB6VDFq6KXa/NPk6
	 dWOVGHmes4x8Op9RW9J/uDoa77xXdTEqgEFDkcVDsn9XmFw/CKkqIBXgLIpi9H1d1I
	 hoKxVuiY0/63A==
Message-ID: <bb4232d6-2387-425f-9b10-811163e74329@kernel.org>
Date: Fri, 10 May 2024 10:10:48 +0200
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] rtla: Fix -t/--trace[=file]
To: John Kacur <jkacur@redhat.com>
References: <20240508212155.71946-1-jkacur@redhat.com>
Content-Language: en-US, pt-BR, it-IT
From: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-trace-devel@vger.kernel.org,
 lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20240508212155.71946-1-jkacur@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/8/24 23:21, John Kacur wrote:
> Normally with a short option we don't provide an equals sign like this
> -tfile.txt
> -t file.txt
> 
> But we do provide an equals sign with the long option like this
> --trace=file.txt
> 
> Also, a good parser should work with a space instead of an equals sign
> --trace file.txt
> 
> Most of these are broken!

So, it is set to work _only_ with =file. It would be better to have
it more robust... yes.

> ./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 -tfile.txt
> Saving trace to ile.txt
> File name truncated
> 
> ./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 -t file.txt
> Saving trace to timerlat_trace.txt
> Default file name used instead of the requested one.
> 
> ./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 -t=file.txt
> Saving trace to file.txt
> This works, but people normally don't use '=' with a short option
> 
> /rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 --trace=file.txt
> Saving trace to ile.txt
> File name truncated
> 
> ./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 --trace file.txt
> timerlat_trace.txt
> Default file name used instead of the requested one.
> 
> After the fix
> 
> ./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 -tfile.txt
> Saving trace to file.txt
> 
> ./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 -t file.txt
> Saving trace to file.txt
> 
> ./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 -t=file.txt
> Saving trace to file.txt
> 
> ./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 --trace=file.txt
> Saving trace to file.txt
> 
> ./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 --trace file.txt
> Saving trace to file.txt
> 
> I also tested -t and --trace without providing a file name both as the
> last requested option and with a following long and short option
> 
> For example
> 
> ./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 -t -u
> ./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 --trace -u
> ./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 -t
> ./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 --trace
> 
> And all correctly do Saving trace to timerlat_trace.txt as expected
> 
> This fix is applied to both timerlat top and hist
> and to osnoise top and hist.

Ok, code wise it is fine. But it is still missing the changes for the --help
messages and man pages. Would you mind addressing them?

For instance, removing the need for the =...

s/
-t/--trace[=file]: save the stopped trace to [file|timerlat_trace.txt]
/
-t/--trace [file]: save the stopped trace to [file|timerlat_trace.txt]
/

Also, for the man page we will have to move the -t option from common_options.rst
to common_timerlat_options.rst and common_osnoise_options.rst to fix this in
man rtla-timerlat-top:

       -t, --trace[=file]
          Save the stopped trace to [file|osnoise_trace.txt].

(it is pointing to the wrong file)

Thanks!
-- Daniel

