Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.120
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794991230;
	b=2E+pd4a9scpz9Huo1qnAxqSYMWdN82O3grhqsjMltOY3FBsutQ8BjHg85SRZZszAZVPk
	 8w0ZDPtdBPDgbwbQMTJXZIBvXZB9zL3YlYoJPhk4tyOvbGicKCkp2kZlD/sNO4hRNB0eT
	 eCy1Qf11ZjgaCnDG+vxz1hiJzSvJHKjIuAQQRFZvzWzutF1P2M2TkVD2B8+ITAKQ29tYd
	 +GeRPCFuV1hcTL6ClNcHVkG+5BTywtsB93GYWLvjjTidwj/MZdf7FfIW7pF7/+y2m/N1f
	 /DR95Kc3M+2iliuBZO+QwpFRpGDilFLpIv1v1OwygBeR+9yvg5OLbloA9DXN8vhwhVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794991230;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/SfLTcNIgEG9LMPzEIvqSJ8sQFaEThlTV5m+IPzEi8o=;
	b=BT7R36lefsGYGhLXBCDUNX4K004t4A4jEx4mASnb9bPaSDaHCtmKZghH17BLmuyBkfh5
	 YCiQpAgYKv75SCVl7OSd6YMN5gClXUutQin+t8drs2Fby0Ruwh/KwvWNsLw7cGl8eiMI9
	 AUp+1ZRHHYrcb6GvYgARVZJ4JQQtstLM0NsHKasVl+EyGC/Lqv1/hZp9KkMX3pujMGPyZ
	 QNgu25ArgAreet9kzvpZ2ZadEdNgwgglNdW25X9Vj/7+46NhFLupmyNF7RW02KiBiqzmk
	 UUMfNTvSgfvIkdrUMLTlKcOpa0ZuW1atZ7RL+PFLGpJTyeton73CzW43t6KvTuURd6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=rvez40xm;
	arc=none smtp.remote-ip=185.125.188.120
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11FCF606A325
	for <linux-trace-devel@vger.kernel.org>; Wed, 18 Nov 2026 08:40:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 11FCF606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=rvez40xm
Received: from openrouter-r.lxd (2.general.fheimes.us.vpn [10.172.66.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id B5E1C4294A;
	Wed, 18 Nov 2026 08:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1794991228;
	bh=/SfLTcNIgEG9LMPzEIvqSJ8sQFaEThlTV5m+IPzEi8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=rvez40xmSUanzkgbxUNfb6gEtNXdI9KuLbilJ9jVmB6djtTwyJcguDY5qtxHGpCGu
	 VeH3wTONLc7Np/ymVHuyjqT3k+EwBIGqAytc/4ywq7L7Z/sWU0t8EhcMAZYOtIPbrN
	 qMgVd44akeujqKq0JcvHgCR7L3pMZNe2XiTijob/w2RKIlhtGSWwC4Ic5XvpCQNXyw
	 RCixTCynNZqZ+U9zd6wCbf9RY9ZPuuIVktU8ON9QwvnN8MYNp4QCLUeUu/baY7Dj3q
	 cyo9gyuvoBN/nwnLI9U4wkhwQo057imPr4Pwuzf/xNbgZOvguK3nA3gV43ID9FpyJ2
	 JBKsK4b8yuT5ldx/UEXvuxi85vmFLSFDT0Bt9NNZfDKt7y3ngli5jB7rWCcpkd6Y++
	 /H8k19bNQhQ/ax2rfbEiXZFjPBTA64or51Q9k/xT5tc/jBq92symSh0+5xkc4WrcsR
	 BixViK8uoaTgAy/ESdPsOT48uc3PCc2ToNVbQ7UZ/MQ2S2b0sdo1VZNRx5nGTk4Rrg
	 CdqPt6sRqRRtwvqsfAH9tvQaT275lnT/HAjfSv4vadBfyZpPCNi2EXFNbjgjFMHVFN
	 +ery/sAcRnu6EKTHGtDjBKJ5/KlvZukWp9Rzo3FIENFnlume+SDr4ObEf+807E//Bw
	 fnhFnWsy+QEW61MTEx2EG8+U=
From: Frank Heimes <frank.heimes@canonical.com>
To: linux-trace-devel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Benjamin Drung <benjamin.drung@canonical.com>,
	Jamie Dolan <jldolan@us.ibm.com>
Subject: [PATCH 1/2] kbuffer: Fix out-of-bounds write of missed events in kbuffer_read_buffer()
Date: Wed, 18 Nov 2026 08:40:23 +0000
Message-ID: <f9679ddfe2224258445c592e53d605b3a317d31f.1794988946.git.frank.heimes@canonical.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1794988946.git.frank.heimes@canonical.com>
References: <cover.1794988946.git.frank.heimes@canonical.com>
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Post: <mailto:linux-trace-devel@vger.kernel.org>
List-Help: <mailto:linux-trace-devel+help@vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-trace-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kbuffer_read_buffer() stores the number of missed events after the
copied events, if the buffer has room for it. But the check for the
room is wrong:

	if (len + kbuf->start <= word_size + buf_len)

It is true whenever the copied sub-buffer header and events fit into
the buffer, which is always the case at this point. If the events fill
up the buffer (which is common, as callers pass a buffer of the
sub-buffer size), the missed events count is written up to 8 bytes
beyond the end of the buffer, and the MISSING_STORED flag is set,
which makes kbuffer_load_subbuffer() read the count beyond the end of
the buffer as well.

For example, libtracefs tracefs_cpu_read() and tracefs_cpu_write()
use kbuffer_read_buffer() for memory mapped ring buffers with a buffer
of the sub-buffer size (in tracefs_cpu_write() on the stack). Running
the libtracefs unit tests under valgrind shows:

  Test: trace cpu pipe ...missed events -1
  ==6341== Invalid read of size 8
  ==6341==    at 0x48A5F34: ??? (in /usr/lib/x86_64-linux-gnu/libtraceevent.so.1.9.0)
  ==6341==    by 0x48A9177: kbuffer_load_subbuffer (in /usr/lib/x86_64-linux-gnu/libtraceevent.so.1.9.0)
  ==6341==    by 0x400D82C: read_trace_cpu_file (tracefs-utest.c:2015)
  [..]
  ==6341==  Address 0x8676a90 is 0 bytes after a block of size 4,096 alloc'd
  missed events 796093548

Fix the check to only store the count when the header, the events and
the count fit into the buffer.

In addition, the flags were OR'ed into the int "len". As MISSING_EVENTS
is bit 31, this makes len negative and sets the upper 32 bits of the
8 byte commit field due to the sign extension. Use an unsigned long
long for the commit value instead.

Fixes: b3f5849527ae ("libtraceevent: Save missed events in kbuffer_read_buffer()")
Link: https://bugs.launchpad.net/bugs/2172071
Signed-off-by: Frank Heimes <frank.heimes@canonical.com>
---
 src/kbuffer-parse.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/src/kbuffer-parse.c b/src/kbuffer-parse.c
index 4a38408..f5d3c38 100644
--- a/src/kbuffer-parse.c
+++ b/src/kbuffer-parse.c
@@ -955,6 +955,7 @@ kbuffer_raw_get(struct kbuffer *kbuf, void *subbuf, struct kbuffer_raw_info *inf
  */
 int kbuffer_read_buffer(struct kbuffer *kbuf, void *buffer, int len)
 {
+	unsigned long long commit;
 	unsigned long long ts;
 	unsigned int type_len_ts;
 	bool do_swap = false;
@@ -1010,6 +1011,8 @@ int kbuffer_read_buffer(struct kbuffer *kbuf, void *buffer, int len)
 
 	write_4(do_swap, buffer + kbuf->start, type_len_ts);
 
+	commit = len;
+
 	/*
 	 * If reading the first event and there are lost events, add it
 	 * to the buffer.
@@ -1024,7 +1027,8 @@ int kbuffer_read_buffer(struct kbuffer *kbuf, void *buffer, int len)
 		else
 			word_size = sizeof(cnt_4);
 
-		if (len + kbuf->start <= word_size + buf_len) {
+		/* Only store the count if there's room for it */
+		if (kbuf->start + len + word_size <= buf_len) {
 			if (word_size == sizeof(cnt_8)) {
 				cnt_8 = kbuf->lost_events;
 				write_8(do_swap, buffer + len + kbuf->start, cnt_8);
@@ -1032,16 +1036,16 @@ int kbuffer_read_buffer(struct kbuffer *kbuf, void *buffer, int len)
 				cnt_4 = kbuf->lost_events;
 				write_4(do_swap, buffer + len + kbuf->start, cnt_4);
 			}
-			len |= MISSING_STORED;
+			commit |= MISSING_STORED;
 		}
-		len |= MISSING_EVENTS;
+		commit |= MISSING_EVENTS;
 	}
 
 	/* Update the size */
 	if (kbuf->read_long == __read_long_8)
-		write_8(do_swap, buffer + 8, len);
+		write_8(do_swap, buffer + 8, commit);
 	else
-		write_4(do_swap, buffer + 8, len);
+		write_4(do_swap, buffer + 8, commit);
 
 	return last_next;
 }
-- 
2.53.0

