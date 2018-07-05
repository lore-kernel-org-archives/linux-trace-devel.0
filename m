Return-Path: <SRS0=lN8X=JV=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:32988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753636AbeGEQih (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Jul 2018 12:38:37 -0400
Date: Thu, 5 Jul 2018 12:38:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/3] kernel-shark-qt: Consolidate load_data_entries and
 load_data_records
Message-ID: <20180705123834.20af348d@gandalf.local.home>
In-Reply-To: <20180705123509.26f1c0c9@gandalf.local.home>
References: <20180703162432.316240087@goodmis.org>
        <993cf66c-316a-1b7a-59a6-a5f607476667@gmail.com>
        <20180705123509.26f1c0c9@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Thu, 5 Jul 2018 12:35:09 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Thanks for the review.

Here's a diff of the patch. Not counting the comment change in the
doxygen header, as I already rebased that.

-- Steve

diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
index 86bd8789..f7560404 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -514,6 +514,7 @@ static void free_rec_list(struct rec_list **rec_list, int n_cpus)
 		while (rec_list[cpu]) {
 			temp_rec = rec_list[cpu];
 			rec_list[cpu] = temp_rec->next;
+			free_record(temp_rec->rec);
 			free(temp_rec);
 		}
 	}
@@ -663,6 +664,7 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
 			temp_rec = rec_list[next_cpu];
 			rec_list[next_cpu] = rec_list[next_cpu]->next;
 			free(temp_rec);
+			/* The record is no longer be referenced */
 			free_record(rec);
 		}
 	}
@@ -742,10 +744,11 @@ ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
 			temp_rec = rec_list[next_cpu];
 			rec_list[next_cpu] = rec_list[next_cpu]->next;
 			free(temp_rec);
-			free_record(rec);
+			/* The record is still referenced in rows */
 		}
 	}
 
+	/* There should be no records left in rec_list */
 	free_rec_list(rec_list, n_cpus);
 	*data_rows = rows;
 	return total;
