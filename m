Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792739457;
	b=LtQKnchNJPZcfvyrEweauS/O6jBqnigE0qRPzomW++OJ49tXoqKHnGETD3UM5pbfNfKh
	 OqZvoPidH5A6NLFaHr8v/95BRKf9VGJfPeEe1GZSDqA+M7NovfnLGpP9zPHTuin2g6BvA
	 BZoH9LedutOkSEnvNM/ome62oUUEtHrCI9S1xU6Vy0xNRNlNA1tmJn84hMvGbPu6lp9Eq
	 tsztebgDhLf2hZ68GvL4bUCNWSYHPoEfWiH02ng21v3wLTZfZ+LB4nJtxpXXWRASceH6Z
	 kWUgzhAkifAHLsGcxxaFuMPWmRh1P4nW2FRvvmhG7Jb10fU5stcXBk8ZqvsHHr9jZVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792739457;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=IS+PpoE4VK+DBidxh0wriilU9p5t13mWtX4ZjK0h7ew=;
	b=oe9FyEqdbT84FjnvD5JghkrhUhXfmHOIToWRhWw2uHMr1bLOnIHUk8ZM77JGMxs0JT05
	 Mf/Tlz2d0HQb7L5BN6yx9hI+QuMkhMExaAhOdSufGM65YiwHwi6rc9TULJAW+KQKRs2WO
	 xwgvONbJhU1zAXtb8KkgAEPE5rbF4Q+C3Clvk+OciVVmcer+pyD9yPejePH+CpNdGC9dn
	 P2mhV55ZO9LBWisWAFNGoE+RxOjKHaf0vVLSHL7bnTdeAALZQ8WC1Cak5mJJ9RWF91CM2
	 oBTt0H+mCiUaiiouKnjE6ocfq9F/Mt9S0b+18QT0HVXUIhBQEpPjZtQx7iuyvi0xy2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=GE01TdHZ;
	arc=none smtp.remote-ip=209.85.210.172
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27ABD606A31A
	for <linux-trace-devel@vger.kernel.org>; Fri, 23 Oct 2026 07:10:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27ABD606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=GE01TdHZ
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8a06ca6e8f4so428053b3a.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 23 Oct 2026 00:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792739456; x=1793344256; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IS+PpoE4VK+DBidxh0wriilU9p5t13mWtX4ZjK0h7ew=;
        b=GE01TdHZTi/Ly6g9Pkz4GV8h5BVS+VCMe7eXiymMiY3CWoC5jB7DSNCi8uktYjiwjS
         P9/6ET8rf/a5AD+hYln/kcxN3oFOUpHT/Xzn7l29UmlQ4zLXKHh9hZS96RBxIxNhhnQU
         D9YxaGKk/4rW5veUtEFZaUN1c0XBe/jm2Mmk0aex5yU1TiDNJFw9H1SgaqxvZDxXS6KT
         nfGkogs4jMN98i4dEtLR1UhuIB9ERbbW0fczE87QsE+25x64l0tyRrJgpN3NwaSrf4Oe
         SmwcuJDXGT6KdpxmQjZugd01kYKZV1o2EwU0PkfiaBk/YLel5jjUtVFJ8UUHSvQ6ooP1
         cOlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792739456; x=1793344256;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IS+PpoE4VK+DBidxh0wriilU9p5t13mWtX4ZjK0h7ew=;
        b=eZy8BFAil2Z422lnFfvlK0r05eay7rT/lGZReyC+c7A7SpBZE8JUX6u+V4RTQJe3+m
         mF1nPI5mHtEjIwhZ931TuAf+ALZBIWuYD0uMVnhk3ghMGG3NKpD3dDIGe90Xv7hvLgLh
         NY+p5y+uerPGzVPdVEBBhVDBvx5VO/0oXgcvsxV2CX5NTyUMF/GMrtTu9FaGzhhPj2AV
         C25qOA4vT7qer3IWLt0steiz0AAXgLVVlGUHDdOvivMNcgoXnEj2WaYN8NOqfm6f10ve
         qEnZRvuAHJrF9Wf0lFHmK/Avp6BBaqvtLV/pSYQ09fWgbuq63ax7i5uNFoI+leJBlGFk
         Qicg==
X-Gm-Message-State: AFq9FYLxub8KA1H7O6J4FW7pH1HZ4LevflyubzpazdEpujfD2A59hh+j
	0mcjQCDPv73aZTzAZPifb20gjsNxGZggMUKWQUydWcN+8gk6sm3Spol1eRjxxtII
X-Gm-Gg: AYBFou187UztlFf5iwXLLD62vdWN1a9NqHWRCZ83hhGCboxbu+Y9BzZXBDV8pLU+hGY
	HTeO3HlsK2DQIMc/vgWInq2yog96lkmrOGZ/VkpQhlVwUb2GxJdnnJ/J0hU649qGv6pQa8AjGJX
	YHNyU76Hy8XMP9aI/DTLnUQ9Wy0NDwBn21+oNlBCULj62ZKXdcQHwb6MOGUop+oCCJ3rQzTq+UN
	6R/28+LQ/19oyxrG+PSaa5q7pueCrfxkVS8mJxvtmqN8YTD/3CczHUbl4+O0WDTMdJyePsLQKsT
	yE3/lu1tQFO00kuUBSlWAJhOPBZ0oK0WhAkfdPOa/xk747HXKEUxfr/5Z3He4M6BVK2jgBoF3SR
	HYDxnRl8cZiq7wx+BL/o6T1qPtIUC6HXMEVc82f5DIhBnugVDsNvuxeAC8Cgl+HGZJK1U0gXofd
	o/Gilx8XfD/VLjatLhlKZfooQxNmJQpG/dGWVnqawhyk/pLEIiIVQqld0+m5eyodimdhz1JJ7T5
	NpeuUrVlZ+zzNfxDhoN9L2vou9FxwFqtq1VF6S+FEWl9BgueUwLReLXpSOAsse/trbVo32qoC8C
	DcBnoVAapIUA6RGzM9CPpg==
X-Received: by 2002:a05:6a00:2da6:b0:88d:f213:6504 with SMTP id d2e1a72fcca58-8a2c765f308mr1285308b3a.42.1792739456328;
        Fri, 23 Oct 2026 00:10:56 -0700 (PDT)
Received: from lipengfei28-ThinkStation-P368.mioffice.cn ([2408:8607:1b00:8:3783:b945:cdf2:bfce])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a2c8dca1fcsm413846b3a.26.2026.10.23.00.10.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 00:10:55 -0700 (PDT)
From: Li Pengfei <ljdlns1987@gmail.com>
X-Google-Original-From: Li Pengfei <lipengfei28@xiaomi.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
	lipengfei28@xiaomi.com
Subject: Re: [PATCH 1/1] trace-cmd: add streaming CPU compression
Date: Fri, 23 Oct 2026 15:10:38 +0800
Message-Id: <20261023071038.2849472-1-lipengfei28@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261020202454.277d4802@gandalf.local.home>
References: <20261015041645.3725172-1-lipengfei28@xiaomi.com> <20261015041645.3725172-2-lipengfei28@xiaomi.com> <20261020202454.277d4802@gandalf.local.home>
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Post: <mailto:linux-trace-devel@vger.kernel.org>
List-Help: <mailto:linux-trace-devel+help@vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-trace-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Tue, 20 Oct 2026 20:24:54 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> This looks like a nice change. But I have some comments below.

Thanks for the review. All of the comments are addressed, replies below.

> Why the above logic? You are writing a zero and updating endianess for a
> zero is pretty useless. Just write the zero and not go through the "endian4".

Right, dropped the conversion:

	unsigned int zero = 0;
	...
	/* A zero needs no endian conversion */
	if (write_fd(handle->fd, &zero, sizeof(zero)) != sizeof(zero))
		return -1;

The write in tracecmd_compress_stream_end() still converts, as that one
writes the real count.

> It's best not to put together if statements that have side effects like
> above. Test each return separately. This is not a fast path. Code
> readability is more important here.
>
> 	if (end == (off_t)-1)
> 		return -1;
>
> 	if (lseek(handle->fd, handle->stream_offset, SEEK_SET) == (off_t)-1))
> 		return -1;
>
> Same here.

Both are split now, tracecmd_compress_stream_end() is four separate
tests:

	end = lseek(handle->fd, 0, SEEK_CUR);
	if (end == (off_t)-1)
		return -1;

	if (lseek(handle->fd, handle->stream_offset, SEEK_SET) == (off_t)-1)
		return -1;

	chunks = handle->stream_chunks;
	endian4 = tep_read_number(handle->tep, &chunks, sizeof(chunks));

	if (write_fd(handle->fd, &endian4, sizeof(endian4)) != sizeof(endian4))
		return -1;

	if (lseek(handle->fd, end, SEEK_SET) == (off_t)-1)
		return -1;

tracecmd_compress_stream_start() had a combined test as well, split too.

> The above structure needs some formatting clean up, but I can do that as a
> separate patch not to confuse what was added here.

Left alone, v2 does not touch the formatting of that struct.

> So if the ".rawsize" files are empty, it tells the final processing that
> there's an error? Could you state this more what the protocol is here.

Asking that found a real bug, thanks. In v1 the error state was a
separate ".rawsize.error" marker written on the way out, and an empty
".rawsize" meant nothing in particular. The problem is what happens when
the recorder never gets to write either one: the writer then finds no
marker at all and stores the compressed bytes as raw ring buffer pages,
which is exactly the case the marker exists to prevent. A recorder
killed outright, or one that failed mid recording, could both end up
there.

So v2 turns the protocol around. The error marker is created before the
first byte is compressed and removed only once the whole stream has been
written:

 /*
  * A recorder that compresses while recording runs in its own process, and the
  * writer only sees the files it leaves behind.  It cannot report a failure, and
  * may not get to run any cleanup at all, so two marker files next to the per
  * CPU file carry that state:
  *
  *   <cpu file>.rawsize.error	Created before the first byte is compressed and
  *				removed once the whole stream has been written.
  *				If the writer finds it, the per CPU data is
  *				unusable and the recording fails.
  *
  *   <cpu file>.rawsize		Written once the stream is complete, and holds
  *				the u64 amount of raw ring buffer data that went
  *				into it.  It tells the writer to copy the file as
  *				is instead of compressing it, and gives it the
  *				uncompressed size, which it cannot work out from
  *				a file it does not decompress.
  *
  * The error marker comes first and is dropped only after the raw size has been
  * written in full, so an incomplete stream can only be left marked as failed,
  * never as complete.  The writer rejects the CPU data if the error marker is
  * there, or if the raw size exists but cannot be read in full.  Neither file
  * exists for a recording that was not compressed while recording.
  */

An empty ".rawsize" is now harmless rather than ambiguous: dropping the
error marker is the last step, so a raw size that was not written in
full still has the CPU file marked as failed.  Any read, flush or
compression failure keeps the marker, as does a SIGKILL.  The writer
takes a CPU file as complete only when the marker is known to be absent,
so an access() or open() that fails for any reason other than ENOENT
fails the recording rather than falling back to raw pages.

Filling a small tmpfs during a recording shows it working. All eight
CPUs hit ENOSPC and kept their markers:

	of.dat.cpu0.rawsize.error ... of.dat.cpu7.rawsize.error

and the writer refuses the recording:

	libtracecmd: Input/output error
	  CPU0 compressed recording failed

Killing the recorder with SIGKILL leaves the same markers behind, and
"trace-cmd restore" on the leftovers is refused as well. v1 was silent
in both cases and stored the compressed data as raw pages.

The comments in trace-recorder.c refer to the header instead of
repeating it.

> I updated the code to use memory mapping of the ring buffer when NOSPLICE
> is set. It appears to still work and should be faster than reading.
>
>   https://lore.kernel.org/all/20261020144953.61d386f1@gandalf.local.home/

Nice, and streaming compression wants exactly that, since it is forced
onto NOSPLICE. It does not get picked up today though: your patch reads
recorder->flags while the tracefs_cpu is opened, and
tracecmd_recorder_set_compression() only sets NOSPLICE after the recorder
exists. So "--stream-compression" alone opens unmapped, while
"--nosplice --stream-compression" does get mapped, as --nosplice sets the
global recorder_flags during argument parsing. Nothing is broken either
way. I have kept it out of v2 so it does not depend on an unapplied
patch, and can send a follow-up once the mapping work lands.

> Please do not add anonymous blocks in the code. Either make this a helper
> function or make it part of the function it is in.
>
> I prefer a helper function, delete_compress_files() or something like that.

Done, with that name:

 /* Remove the marker files that a recorder compressing its stream leaves behind */
 static void delete_compress_files(const char *cpu_file)
 {
	char file[PATH_MAX];

	snprintf(file, sizeof(file), "%s%s", cpu_file,
		 TRACE_CMD_RAW_SIZE_SUFFIX);
	unlink(file);

	snprintf(file, sizeof(file), "%s%s%s", cpu_file,
		 TRACE_CMD_RAW_SIZE_SUFFIX, TRACE_CMD_REC_ERROR_SUFFIX);
	unlink(file);
 }

> Isn't maxkb not allowed with stream_compression?
>
> Same.

It is not, so those blocks were pointless. Both are gone and the maxkb
paths are back to their original shape.

The two other NOSPLICE assignments v1 added in create_recorder_instance()
turned out to be redundant as well, since
tracecmd_recorder_set_compression() sets the flag before recording
starts. v2 drops those too, so it no longer touches NOSPLICE in
trace-record.c at all. The existing assignments for the vsock fallback
and for --nosplice itself are untouched.

> You don't need to test CMD_record_agent, that's more of an internal option.

Removed.

Two things not in your comments. v2 has tracecmd_flush_recording()
report a negative flush to its caller instead of always returning the
padded size, as a failed compression there has to reach the marker
protocol. It retries EINTR like tracecmd_start_recording() already does,
so an interrupted read is not turned into a failure. The only non
streaming caller affected is "trace-cmd extract", which now dies on a
read error rather than writing a short recording silently. It also
checks the return of tracefs_cpu_stop() on the way out, as a buffer that
stayed blocking turns a zero read into "nothing yet" rather than "done",
which would end the stream early.

Reviewing the writer side for this turned up a pre-existing crash in
tracecmd_write_cpu_data() that has nothing to do with compression: the
warning for a CPU file that cannot be opened passes the file descriptor
to a "%s". I sent that separately, as it stands on its own:

  https://lore.kernel.org/linux-trace-devel/20261023065528.2702469-1-lipengfei28@xiaomi.com/

I ran the usual record/report rounds for zlib and zstd with and without
--stream-compression and --nosplice, extract on top of this, and the
ENOSPC and SIGKILL cases above, on x86_64 and on arm64.

> Other than that, this looks good.

v2 follows.

Thanks,
Li Pengfei
