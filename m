Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.120
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794997611;
	b=vSR8oGLXDJDp2zl0+ukIMoEnJFunPepgQk2hmQ9BH2SETiKndQ5Y8dh6SlOhN2foMB10
	 KRqyXfjHgQnFg91huBtvgk6aU+7cx3ee8GLq7Iwe31sOGPJRkUDoIQxHxkXbZnciyz7O+
	 MeL4B/M4xRI/jXNgIqnkD3yxNekkCIucRqNIX0E40ZV4HS8Gdti917a6WbBs/lB9BnJNV
	 3gNLfcOzWj+T1rjcFaShogVe7yfbnTv4BqapNb9PaZkoZFrtPygiTmh1eKIC8Ra0XiD3y
	 4kGN/SGbYWOkq22Y4uqtcMZaKoUyFYpm1YIF3KHOeDjwNRiQizD5XwYOAktZFRxdOOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794997611;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=h682x+PORbOc+0SyWsUsKzzjdbNhO7OC4YDOv6dQXq0=;
	b=yC0DsrwhAw4xrJi+dOhTMfLvP3GRcB9T7Rk1GpSKOlgoDDnrWQIjZeaqU3i/at6pgHPg
	 Klyo2b05OWS9G1tnvfkJdgHbi20A8xslpsfF+9BmUGxJs4UjfMuODlihw+jMRrlaEzKJi
	 notV2IH5eyWDLwa8S3K7vI5LJ+hcAtOz2OmpyDgVq3q5GsRmsdhOtzSdsQkvz4l5QB+tX
	 B/UN7EGMg/FYi2Ig6CAnTN37i14aP4L4ouEXrx24zaGHiJyq3/q3AByro5r1lLnA7op+0
	 vN+1CG2eU71xrIYCyhkIIVahut9hvCWinBwv/z8YE1m+8pCkXoON9uShfb401vL0beA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=TrYxsU26;
	arc=none smtp.remote-ip=185.125.188.120
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EB0606A325
	for <linux-trace-devel@vger.kernel.org>; Wed, 18 Nov 2026 10:26:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B0EB0606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=TrYxsU26
Received: from openrouter-r.lxd (2.general.fheimes.us.vpn [10.172.66.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id C61CB42276;
	Wed, 18 Nov 2026 10:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1794997607;
	bh=h682x+PORbOc+0SyWsUsKzzjdbNhO7OC4YDOv6dQXq0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version;
	b=TrYxsU26j+z4oRaYHTpKTADL3SRQcHtOiyGi+F5VI18nQYF5BewJTk1UCVz/V2Y6O
	 +iVN3TQi5ba4R7E1qLeTcdiEapOhOwO7WVKPKyzbOUqYazqe2Zt4xdorVjB5h5uu7K
	 qIucZ7G6iC1taWNni7aa6+mDe8sUy1IcZ4QuwVEO9GJgWoh9YGnGzg1Q2/DS5aBl5A
	 acHukHr0x6MqDjFWyx/EJxaYemRJHXNxJFPVM3d1PrMGt8ZqaDLwmCnEPrhcRm57d+
	 nv2F7bV+LQsMZjiQKcLqV8arB+YZQaIFHC9Gn0Sj156WllpuK4PCVPsmPzSMusJje7
	 p7C7sF5CwwYZZMHL5AbnPKv3DGJ6POYzWda8jOi66ko6qIhEMrsxsADW9jxrtyCWAe
	 HCQSJsMkUw7bQH+q4UNriAcg96fRiWPzYMgEm3nSV0uzXDVvlGLt8IySqhnLGh5yLe
	 wYxVu5XFc0Be3Dt2jytQKi7DkVNIgASZH9stFAOTMD/NdkYFiJ22OAXEgQearK8U30
	 e3vDJ/lT1R8t7VFeumj1kRQZ0rjRBeBGz0CQc58YjlTCEbiPq6+XJSSBts1uMT220q
	 YjvjOAGGk5XFTtSj8YVFz1FHLT+lWMDfwYlyjCkVTPloJX912B6BuCb4Vx13j+pUaG
	 cW830+D8qW5LkezUh2ORRtrA=
From: Frank Heimes <frank.heimes@canonical.com>
To: linux-trace-devel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Benjamin Drung <benjamin.drung@canonical.com>,
	Jamie Dolan <jldolan@us.ibm.com>
Subject: [PATCH] libtracefs: Do not miss sub-buffers when reading a memory mapped buffer
Date: Wed, 18 Nov 2026 10:26:44 +0000
Message-ID: <20261118102644.3392133-1-frank.heimes@canonical.com>
X-Mailer: git-send-email 2.53.0
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

When the reader sub-buffer of a memory mapped ring buffer has no more
events, tfs_mmap_load_subbuf() calls TRACE_MMAP_IOCTL_GET_READER to get
the next sub-buffer, and if the reader sub-buffer did not change, it
assumes that there are no more events to read.

But the kernel only swaps in a new reader sub-buffer if it accounted all
the events of the current one as read. Otherwise it only moves its read
position to the end of the current sub-buffer and returns without
swapping. This happens if events were added to the reader sub-buffer
after it was swapped in (as the reader can swap in the sub-buffer that
is being written to): ring_buffer_map_get_reader() marks the events of
the sub-buffer at the time of the swap as read, but user space reads
all the events that are on the sub-buffer when it loads it.

In that case tfs_mmap_load_subbuf() returns 0, although the next
sub-buffer may have events. For tracefs_cpu_read() and
tracefs_cpu_write() this is only a delay until the next call, but
tracefs_cpu_flush() and tracefs_cpu_flush_write() stop on 0, so the
last events of a trace are lost.

This makes the "trace cpu pipe" unit test fail now and then for memory
mapped buffers, in particular under valgrind, which widens the race
window. For example on ppc64el, 1 of 3277 events stayed in the ring
buffer. Tracing tfs_mmap_load_subbuf() shows:

  GET_READER: id 20 -> 19, read 0 -> 51340, 65520 bytes loaded
  GET_READER: id 19 -> 19, read 51340 -> 65520, returns 0

If the reader sub-buffer did not change but the kernel moved its read
position, check the current sub-buffer for new events, and if there
are none, call TRACE_MMAP_IOCTL_GET_READER again.

Fixes: 4ede86e9a48d ("libtracefs: Enable mmapped ring buffer")
Link: https://bugs.launchpad.net/bugs/2172071
Signed-off-by: Frank Heimes <frank.heimes@canonical.com>
---

Notes:
    This was found while looking into the libtracefs unit test failures
    reported here:
    
      https://lore.kernel.org/linux-trace-devel/39efe87bec205b7f809b8aa49db635b6465ee530.camel@canonical.com/
    
    The kernel side is ring_buffer_map_get_reader(): if
    cpu_buffer->reader_page->read < reader_size it only advances the reader
    to the end of the page and does not call rb_get_reader_page().
    
    Tested on ppc64el (POWER9, 64K pages, kernel 7.3) with 20 runs of the
    "trace cpu pipe" test under valgrind: without this patch 4 of 20 runs
    lost an event (cnt=3276 expect=3277, 1 entry left in the ring buffer),
    with it 0 of 20. With this patch, the kbuffer_read_buffer() fix in
    libtraceevent [1] and the unit test fixes that I'll post separately,
    "make test" and "make test_mem" pass (37/37) on top of master.
    
    [1] https://lore.kernel.org/linux-trace-devel/cover.1794988946.git.frank.heimes@canonical.com/T/#u

 src/tracefs-mmap.c | 43 +++++++++++++++++++++++++++++++------------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/src/tracefs-mmap.c b/src/tracefs-mmap.c
index 7530805..39dad4c 100644
--- a/src/tracefs-mmap.c
+++ b/src/tracefs-mmap.c
@@ -205,18 +205,37 @@ __hidden int tfs_mmap_load_subbuf(void *mapping, struct kbuffer *kbuf)
 		return 1;
 	}
 
-	/* See if a new page is ready? */
-	if (get_reader(tmap) < 0)
-		return -1;
-	id = tmap->map->reader.id;
-	data = tmap->data + tmap->map->subbuf_size * id;
-
-	/*
-	 * If the sub-buffer hasn't changed, then there's no more
-	 * events to read.
-	 */
-	if (data == kbuffer_subbuffer(kbuf))
-		return 0;
+	for (;;) {
+		__u32 read = tmap->map->reader.read;
+
+		/* See if a new page is ready? */
+		if (get_reader(tmap) < 0)
+			return -1;
+		id = tmap->map->reader.id;
+		data = tmap->data + tmap->map->subbuf_size * id;
+
+		if (data != kbuffer_subbuffer(kbuf))
+			break;
+
+		/*
+		 * If the sub-buffer hasn't changed and the kernel did not
+		 * move its read position, then there's no more events to read.
+		 */
+		if (tmap->map->reader.read == read)
+			return 0;
+
+		/*
+		 * Events were added to the reader sub-buffer after it was
+		 * swapped in. In that case the kernel only moves its read
+		 * position forward to the end of the sub-buffer, and does
+		 * not swap in a new one. Check for new events on the
+		 * current sub-buffer, and if there are none, ask again
+		 * for the next sub-buffer.
+		 */
+		kbuffer_refresh(kbuf);
+		if (kbuffer_curr_size(kbuf))
+			return 1;
+	}
 
 	kbuffer_load_subbuffer(kbuf, data);
 	return 1;
-- 
2.53.0

