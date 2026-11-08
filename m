Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=216.40.44.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794133119;
	b=p2gbed5hsmcwKAF/cC/McLCoDVTz3cpEBjydLyYImuaQD4ttxCXdEzidnNVlydW5e95P
	 y2TNTx+T79EVJIGN5uiIROtFb7j5s2NsSfXmKEJJU+f75kUmnL+Pgk4wF/kSzT33cEufg
	 eHcyWjsTNRZIE70fzyDJPocMntmMcJnnQmUFCc7t+HjzQ07HWgqaISqQKfDcEc17blnHp
	 hZGU4dg5s6nD1RrnBPRNMZSCXrrkjvTp+lwoiSjzABPvq05SryG8ahnnuAjV9SEpfbOOK
	 heYJcz/uphuZ+TjPxFsu3yRb+6WpFWdnEDnDjL72mSTKBEDc7i/+bm5fyMNRU2vwGDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794133119;
	h=DMARC-Filter:Received:Received:Date:From:To:Subject:Message-ID:
	 X-Mailer:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Rspamd-Server:X-Rspamd-Queue-Id:X-Stat-Signature:X-Spam-Status:
	 X-Session-Marker:X-Session-ID:DKIM-Signature:X-HE-Tag:X-HE-Meta;
	bh=IpEBbSd80Nl4/Lv03VTOWUHuakQCYmcO99F1XTe0lzg=;
	b=v1uFFHBrfNkz5wemnLsCnMrZA3gzOLitKMlZnhCZpho6r1qSGusJfvTPU1+JMs9A3ZL3
	 ier2xDOLh2cEdaP9/L3BI+aogrijt/2iiJHM64qecQ1FZRre0kRCIiCBPONgDvEqcq+9x
	 jI9fCQJWU2/inmxlCxyE9LhxUJONIFJmis7akXGxmdPJcdoAGvAX8FfMmKh7U6bpr661P
	 s3qyAhK920ZMGQHejXZl8Z+628x1masgU5ao9zJXgPyHf/wEIufoN4IvNB9ypVgli4d46
	 Oo2b9Ee0uhRq3N/IBpEhqxWIjnHvDkRxodPnBmW3+LTN0C5VlLiYQurHdBMBZ5YUrpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=goodmis.org;
	spf=pass smtp.mailfrom=goodmis.org;
	dkim=pass header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b="GwcCuC/S";
	arc=none smtp.remote-ip=216.40.44.11
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657AC606A31C
	for <linux-trace-devel@vger.kernel.org>; Sun,  8 Nov 2026 10:18:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 657AC606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=GwcCuC/S
Received: from omf14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4965A120437
	for <linux-trace-devel@vger.kernel.org>; Sun,  8 Nov 2026 10:18:37 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf14.hostedemail.com (Postfix) with ESMTPA id 792182F
	for <linux-trace-devel@vger.kernel.org>; Sun,  8 Nov 2026 10:18:35 +0000 (UTC)
Date: Sun, 8 Nov 2026 05:18:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Remove unused variable mode in
 tracefs_cpu_alloc_fd()
Message-ID: <20261108051831.5c59c6ba@fedora>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Post: <mailto:linux-trace-devel@vger.kernel.org>
List-Help: <mailto:linux-trace-devel+help@vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-trace-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: 792182F
X-Stat-Signature: umr6ubu3mnkpdxs7ntfwg33zsjc47ks1
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/aCXiNcQkPhhguOOkYOy3RAGxQ5WwdXDM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:subject:message-id:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=IpEBbSd80Nl4/Lv03VTOWUHuakQCYmcO99F1XTe0lzg=; b=GwcCuC/SmnrS+h8BUrgNLCeVhKEojur0hTYPXB8vmdJy+QbM5ymX6DPI31gfsmaGVnVQjdlr9yd0cUCwDvKxxb6pb2MqPIYuyjGnRfrttiYBUbkjDJE/KsEkCi5zsZtp7m92rqvC95eJywwwwzNJQXO7MJW22MdUF/mYYkbtvV8=
X-HE-Tag: 1794133115-659859
X-HE-Meta: U2FsdGVkX1+CCWcZgwrh74uFttwC32xkNpwhIPV9GsoYsXsFzYGyyh3Som33Xy2t4t5ykIDMjTsBK+5Kx1n3Mcieh+nyT4EBgok1ck/HCdrw4hV5HkGrqrW1xwCpBTlTxwKhGM9XcSJ1e4xixt15Re8+rA0USXlhuhXsgmE30KVsAiOW2Dc4xwtUNlAN7+n9ZajtZPPH3loPrI3ZSc+3TUKYYKzk1VvmKsd7ndtdWbbm7Wn34FhInmqajQMBqUX29as922ZrW4PQWNE0sc65YV3JoHtqjxkv70Od5+BEoc8jPZSKLJA2Hj4lsZhHRwPUWL8tFpjVe3f8c3WIN4abtVEt4xEtrCPZyZ8v0KNqZ4DKZAe4BFh5hoYvEBEl4C0B

From: Steven Rostedt <rostedt@goodmis.org>

When tracefs_cpu_alloc_fd() was introduced, it broke up
-tracefs_cpu_open() to use parts in multiple functions. As
tracefs_cpu_alloc_fd() was created from -tracefs_cpu_open(), it had the
mode variable from that function, but it never used it.
Remove the unuesd mode variable.

Fixes: da88fcef46b46 ("libtracefs: Add tracefs_cpu_alloc_fd() and tracefs_cpu_free_fd()")
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 src/tracefs-record.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/src/tracefs-record.c b/src/tracefs-record.c
index f5197c458c07..644082b6ba0e 100644
--- a/src/tracefs-record.c
+++ b/src/tracefs-record.c
@@ -54,17 +54,14 @@ struct tracefs_cpu *
 tracefs_cpu_alloc_fd(int fd, int subbuf_size, bool nonblock)
 {
 	struct tracefs_cpu *tcpu;
-	int mode = O_RDONLY;
 	int ret;
 
 	tcpu = calloc(1, sizeof(*tcpu));
 	if (!tcpu)
 		return NULL;
 
-	if (nonblock) {
-		mode |= O_NONBLOCK;
+	if (nonblock)
 		tcpu->flags |= TC_NONBLOCK | TC_PERM_NONBLOCK;
-	}
 
 	tcpu->splice_pipe[0] = -1;
 	tcpu->splice_pipe[1] = -1;
-- 
2.53.0

